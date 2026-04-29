#include "rclcpp/rclcpp.hpp"
#include "sensor_msgs/msg/laser_scan.hpp"
#include "geometry_msgs/msg/twist.hpp"
#include "nav_msgs/msg/odometry.hpp"
#include <cmath>
#include <vector>
#include <numeric>

class CorridorNavigationNode : public rclcpp::Node
{
public:
    CorridorNavigationNode() : Node("corr_nav_node")
    {
        // Load parameters
        loadParameters();

        RCLCPP_INFO(this->get_logger(), "CorridorNavigationNode started");

        // Publisher for cmd_vel
        cmd_vel_pub_ = this->create_publisher<geometry_msgs::msg::Twist>("/PioneerP3DX/cmd_vel", 10);
        // Subscriber for robot pose
        pose_sub_ = this->create_subscription<nav_msgs::msg::Odometry>("/PioneerP3DX/odom", 10,
            std::bind(&CorridorNavigationNode::odomCallback, this, std::placeholders::_1));

        // Subscriber for laser scan data
        laser_sub_ = this->create_subscription<sensor_msgs::msg::LaserScan>("/PioneerP3DX/laser_scan", 10,
            std::bind(&CorridorNavigationNode::laserCallback, this, std::placeholders::_1));

        // Timer to publish velocity commands at regular intervals
        timer_ = this->create_wall_timer(
            std::chrono::milliseconds(time_step_),
            std::bind(&CorridorNavigationNode::controlLoop, this));

        RCLCPP_INFO(this->get_logger(), "Corridor Navigation Node Initialized");
        measured_data_=false;
    }

private:
    void loadParameters()
    {
         // Declare parameters of this node (name, initial_value)
        this->declare_parameter("time_step", 25);  // in milliseconds
        this->declare_parameter("max_linear_speed", 1.2);
        this->declare_parameter("max_angular_speed", 2.0);
        this->declare_parameter("wheel_base", 0.331);
        this->declare_parameter("wheel_radius", 0.097518);
        this->declare_parameter("corridor_width", 10.0);  // meters
        this->declare_parameter("look_ahead_distance", 1.0);  // meters 
        // Read parameters
        time_step_ = this->get_parameter("time_step").as_int();
        max_linear_speed_ = this->get_parameter("max_linear_speed").as_double();
        max_angular_speed_ = this->get_parameter("max_angular_speed").as_double();
        wheel_base_ = this->get_parameter("wheel_base").as_double();
        wheel_radius_ = this->get_parameter("wheel_radius").as_double();
        corridor_width_ = this->get_parameter("corridor_width").as_double();
        look_ahead_distance_ = this->get_parameter("look_ahead_distance").as_double();

        RCLCPP_INFO(this->get_logger(), 
            "max_linear_speed: %.2f, max_angular_speed: %.2f, wheel_base: %.2f, wheel_radius: %.2f, corridor_width: %.2f, look_ahead_distance: %.2f", 
            max_linear_speed_, max_angular_speed_, wheel_base_, wheel_radius_, corridor_width_, look_ahead_distance_);
    }

    void odomCallback(const nav_msgs::msg::Odometry::SharedPtr msg)
    {
        current_x_ = msg->pose.pose.position.x;
        current_y_ = msg->pose.pose.position.y;
        // Extract yaw from quaternion
        double siny_cosp = 2 * (msg->pose.pose.orientation.w * msg->pose.pose.orientation.z + msg->pose.pose.orientation.x * msg->pose.pose.orientation.y);
        double cosy_cosp = 1 - 2 * (msg->pose.pose.orientation.y * msg->pose.pose.orientation.y + msg->pose.pose.orientation.z * msg->pose.pose.orientation.z);
        current_theta_ = std::atan2(siny_cosp, cosy_cosp);
    }

    // Ajusta una recta y = m*x + b a los puntos del láser en [angle_min_rad, angle_max_rad]
    // Devuelve {m, b}: m es la pendiente (orientación) y b la distancia a la pared
    std::pair<double, double> extractWall(const sensor_msgs::msg::LaserScan::SharedPtr& msg,
        double angle_min_rad, double angle_max_rad)
    {
        double a_min = msg->angle_min;
        double a_inc = msg->angle_increment;
        int n = msg->ranges.size();

        double sum_x = 0.0, sum_y = 0.0, sum_xx = 0.0, sum_xy = 0.0;
        int count = 0;

        for (int i = 0; i < n; i++) {
            double angle = a_min + i * a_inc;
            if (angle < angle_min_rad || angle > angle_max_rad)
                continue;
            double r = msg->ranges[i];
            if (!std::isfinite(r) || r <= 0.0)
                continue;
            double x = r * std::cos(angle);
            double y = r * std::sin(angle);
            sum_x  += x;
            sum_y  += y;
            sum_xx += x * x;
            sum_xy += x * y;
            count++;
        }

        if (count < 2)
            return {0.0, std::numeric_limits<double>::infinity()};

        double denom = count * sum_xx - sum_x * sum_x;
        if (std::abs(denom) < 1e-9)
            return {0.0, sum_y / count};

        double m = (count * sum_xy - sum_x * sum_y) / denom;
        double b = (sum_y - m * sum_x) / count;
        return {m, b};
    }

    void laserCallback(const sensor_msgs::msg::LaserScan::SharedPtr msg)
    {
        // Estimar pared izquierda (30° a 150°) y pared derecha (-150° a -30°)
        auto [ml, bl] = extractWall(msg,  M_PI / 6.0,  5.0 * M_PI / 6.0);
        auto [mr, br] = extractWall(msg, -5.0 * M_PI / 6.0, -M_PI / 6.0);

        m_left_  = ml;  b_left_  = bl;
        m_right_ = mr;  b_right_ = br;

        // Distancia frontal (media simple en ±15°)
        double a_min = msg->angle_min;
        double a_inc = msg->angle_increment;
        double sum = 0.0; int cnt = 0;
        for (int i = 0; i < (int)msg->ranges.size(); i++) {
            double angle = a_min + i * a_inc;
            if (angle > -M_PI / 12.0 && angle < M_PI / 12.0) {
                double r = msg->ranges[i];
                if (std::isfinite(r)) { sum += r; cnt++; }
            }
        }
        dist_front_ = (cnt > 0) ? sum / cnt : std::numeric_limits<double>::infinity();

        measured_data_ = true;

        RCLCPP_INFO(this->get_logger(),
            "Left: m=%.3f b=%.3f | Right: m=%.3f b=%.3f | Front=%.2f m",
            m_left_, b_left_, m_right_, b_right_, dist_front_);
    }

    void controlLoop()
    {
        if (!measured_data_) {
            RCLCPP_WARN_ONCE(this->get_logger(), "Waiting for laser data...");
            return;
        }
        else {
            measured_data_ = false; // Reset flag

            // Distancias a las paredes: b_left_ > 0, b_right_ < 0
            double dist_left  = b_left_;
            double dist_right = std::abs(b_right_);
            // Orientación: media de las pendientes de ambas paredes → θ = atan(m)
            double theta = std::atan((m_left_ + m_right_) / 2.0);

            RCLCPP_INFO(this->get_logger(),
                "Left=%.2f m, Right=%.2f m, Theta=%.3f rad", dist_left, dist_right, theta);

            /////////////////// PUT YOUR CONTROL CODE HERE ///////////

            double lateral_error = dist_left - (corridor_width_ / 2.0);
            double y_L;
            double L;
            double linear_velocity;
            double angular_velocity;

            if (dist_right > corridor_width_) {
                // Curva derecha detectada (pared derecha desaparece)
                linear_velocity  = max_linear_speed_ / 8.0;
                angular_velocity = -max_angular_speed_;
                RCLCPP_INFO(this->get_logger(), "CURVA: v=%.2f w=%.2f", linear_velocity, angular_velocity);
            } else {
                // Seguimiento normal de pasillo (Pure Pursuit)
                y_L = lateral_error * std::cos(theta) - look_ahead_distance_ * std::sin(theta);
                L = look_ahead_distance_;
                double curvature = 2.0 * y_L / (L * L);
                linear_velocity  = max_linear_speed_ / 4.0;
                angular_velocity = std::max(-max_angular_speed_, std::min(max_angular_speed_, curvature * linear_velocity));
            }



            
            geometry_msgs::msg::Twist cmd_vel_msg;
            cmd_vel_msg.linear.x = linear_velocity;
            cmd_vel_msg.angular.z = angular_velocity;
            cmd_vel_pub_->publish(cmd_vel_msg);
        }
    }

    // Publishers and Subscribers
    rclcpp::Publisher<geometry_msgs::msg::Twist>::SharedPtr cmd_vel_pub_;
    rclcpp::Subscription<nav_msgs::msg::Odometry>::SharedPtr pose_sub_;
    rclcpp::Subscription<sensor_msgs::msg::LaserScan>::SharedPtr laser_sub_;
    rclcpp::TimerBase::SharedPtr timer_;

    // Parameters
    int time_step_;
    double max_linear_speed_;
    double max_angular_speed_;      
    double wheel_base_;
    double wheel_radius_;
    double corridor_width_;
    double look_ahead_distance_;

    // Actual robot position
    double current_x_ = 0.0;
    double current_y_ = 0.0;
    double current_theta_ = 0.0;  

    // Laser data — paredes estimadas: y = m*x + b
    double m_left_  = 0.0, b_left_  = 0.0;   // pared izquierda
    double m_right_ = 0.0, b_right_ = 0.0;   // pared derecha
    double dist_front_ = std::numeric_limits<double>::infinity();
    double measured_data_ = false;

};  

int main(int argc, char * argv[])
{
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<CorridorNavigationNode>());
    rclcpp::shutdown();
    return 0;
}