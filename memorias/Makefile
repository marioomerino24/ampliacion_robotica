# ===== Makefile — Memorias de prácticas =====
LATEXMK = latexmk -pdf -interaction=nonstopmode -file-line-error

# Directorios de prácticas (robótica móvil)
MR_LABS = robotica_movil/lab1_caminos_explicitos \
          robotica_movil/lab1_caminos_implicitos \
          robotica_movil/lab2_percepcion \
          robotica_movil/lab4_campos_potenciales

# Cuando haya prácticas de manipuladores, añadir aquí:
# MANIP_LABS = manipuladores/...

ALL_LABS = $(MR_LABS)

# ===== Targets =====
.PHONY: all clean $(ALL_LABS)

all: $(ALL_LABS)

$(ALL_LABS):
	@echo "════ Compilando $@ ════"
	cd $@ && $(LATEXMK) main.tex

# Targets individuales con nombres cortos
.PHONY: lab1i lab1ii lab2 lab4

lab1i:  robotica_movil/lab1_caminos_explicitos
lab1ii: robotica_movil/lab1_caminos_implicitos
lab2:   robotica_movil/lab2_percepcion
lab4:   robotica_movil/lab4_campos_potenciales

# Limpieza
clean:
	@for lab in $(ALL_LABS); do \
		echo "Limpiando $$lab..."; \
		cd $$lab && latexmk -C main.tex 2>/dev/null; cd $(CURDIR); \
	done

# ===== Google Drive (rclone) =====
DRIVE_ROOT = --drive-root-folder-id 12xhwg9u4H9kpjFGLLnkce3h6Y830ahor

# Nombres para Drive: [Lab-ID] Nombre.pdf
MR_NAMES = "[Lab-MR1-I] Caminos Explícitos" \
           "[Lab-MR1-II] Caminos Implícitos" \
           "[Lab-MR2] Percepción Entorno" \
           "[Lab-MR4] Campos Potenciales"

.PHONY: upload upload-movil

upload: upload-movil

upload-movil: all
	@echo "════ Subiendo memorias a Google Drive ════"
	@mkdir -p /tmp/memorias_upload
	@cp robotica_movil/lab1_caminos_explicitos/main.pdf  "/tmp/memorias_upload/[Lab-MR1-I] Caminos Explícitos.pdf"
	@cp robotica_movil/lab1_caminos_implicitos/main.pdf  "/tmp/memorias_upload/[Lab-MR1-II] Caminos Implícitos.pdf"
	@cp robotica_movil/lab2_percepcion/main.pdf          "/tmp/memorias_upload/[Lab-MR2] Percepción Entorno.pdf"
	@cp robotica_movil/lab4_campos_potenciales/main.pdf  "/tmp/memorias_upload/[Lab-MR4] Campos Potenciales.pdf"
	rclone sync /tmp/memorias_upload/ "drive:Robótica Móvil/Memorias" $(DRIVE_ROOT) --progress
	@rm -rf /tmp/memorias_upload
	@echo "════ Subida completada ════"
