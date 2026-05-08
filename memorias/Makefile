# ===== Makefile — Memorias de prácticas =====
LATEXMK = latexmk -pdf -interaction=nonstopmode -file-line-error

# Directorios de prácticas (robótica móvil)
MR_LABS = robotica_movil/lab1-I_caminos_explicitos \
          robotica_movil/lab1-II_caminos_implicitos \
          robotica_movil/lab2_percepcion \
          robotica_movil/lab3_campos_potenciales \
          robotica_movil/lab4_dijkstra \
          robotica_movil/lab5_a_estrella \
          robotica_movil/lab6_navegacion_completa

# Cuando haya prácticas de manipuladores, añadir aquí:
# MANIP_LABS = manipuladores/...

ALL_LABS = $(MR_LABS)

# ===== Targets =====
.PHONY: all clean $(ALL_LABS)

all: $(ALL_LABS)

$(ALL_LABS):
	@echo "════ Compilando $@ ════"
	cd $@ && $(LATEXMK) main.tex

# Targets individuales con nombres cortos (nomenclatura oficial Lab-MR)
.PHONY: lab1-I lab1-II lab2 lab3 lab4 lab5 lab6

lab1-I:  robotica_movil/lab1-I_caminos_explicitos
lab1-II: robotica_movil/lab1-II_caminos_implicitos
lab2:    robotica_movil/lab2_percepcion
lab3:    robotica_movil/lab3_campos_potenciales
lab4:    robotica_movil/lab4_dijkstra
lab5:    robotica_movil/lab5_a_estrella
lab6:    robotica_movil/lab6_navegacion_completa

# Limpieza
clean:
	@for lab in $(ALL_LABS); do \
		echo "Limpiando $$lab..."; \
		cd $$lab && latexmk -C main.tex 2>/dev/null; cd $(CURDIR); \
	done

# ===== Google Drive (rclone) =====
DRIVE_ROOT = --drive-root-folder-id 12xhwg9u4H9kpjFGLLnkce3h6Y830ahor

# Nombres para Drive: [Lab-ID] Nombre.pdf (nomenclatura oficial)
MR_NAMES = "[Lab-MR 1-I] Caminos Explícitos" \
           "[Lab-MR 1-II] Caminos Implícitos" \
           "[Lab-MR 2] Percepción Entorno" \
           "[Lab-MR 3] Campos Potenciales" \
           "[Lab-MR 4] Dijkstra" \
           "[Lab-MR 5] A Estrella" \
           "[Lab-MR 6] Navegación Completa"

.PHONY: upload upload-movil

upload: upload-movil

upload-movil: all
	@echo "════ Subiendo memorias a Google Drive ════"
	@mkdir -p /tmp/memorias_upload
	@cp robotica_movil/lab1-I_caminos_explicitos/main.pdf  "/tmp/memorias_upload/[Lab-MR 1-I] Caminos Explícitos.pdf"
	@cp robotica_movil/lab1-II_caminos_implicitos/main.pdf  "/tmp/memorias_upload/[Lab-MR 1-II] Caminos Implícitos.pdf"
	@cp robotica_movil/lab2_percepcion/main.pdf          "/tmp/memorias_upload/[Lab-MR 2] Percepción Entorno.pdf"
	@cp robotica_movil/lab3_campos_potenciales/main.pdf  "/tmp/memorias_upload/[Lab-MR 3] Campos Potenciales.pdf"
	@cp robotica_movil/lab4_dijkstra/main.pdf            "/tmp/memorias_upload/[Lab-MR 4] Dijkstra.pdf"
	@cp robotica_movil/lab5_a_estrella/main.pdf          "/tmp/memorias_upload/[Lab-MR 5] A Estrella.pdf"
	@cp robotica_movil/lab6_navegacion_completa/main.pdf "/tmp/memorias_upload/[Lab-MR 6] Navegación Completa.pdf"
	rclone sync /tmp/memorias_upload/ "drive:Robótica Móvil/Memorias" $(DRIVE_ROOT) --progress
	@rm -rf /tmp/memorias_upload
	@echo "════ Subida completada ════"
