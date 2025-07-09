# Salesforce Leads API Integration Project

Este proyecto fue desarrollado como práctica en Salesforce para realizar una integración con una API externa, mantener la información sincronizada y automatizar procesos en los objetos Lead y Country.

---

## 🎯 Objetivos del Proyecto

1. **Importar información de países** desde la API [https://countrylayer.com](https://countrylayer.com)
2. **Actualizar la información diariamente** en Salesforce
3. **Mostrar información del país** en el Lead usando un trigger
4. **Validar condiciones al cambiar el Owner del Lead**
5. **Registrar la fecha de asignación del Owner** mediante un Flow
6. **Subir todo el desarrollo a un repositorio GitHub**

---

## 🔧 Funcionalidades Desarrolladas

### 1. API REST Integration con CountryLayer
- Clase Apex `CountryLayerService`
- Llama a la API REST de CountryLayer
- Extrae: Nombre del país, código Alpha2, Alpha3, capital, región y bloques regionales

### 2. Actualización diaria automática
- Se creó un `Schedulable Apex` llamado `CountryDataScheduler`
- Ejecuta una llamada a la API una vez al día
- Compara y actualiza registros existentes

### 3. Trigger sobre Leads
- `LeadCountryTrigger` asocia automáticamente el país del Lead con el objeto Country
- Muestra campos del país (capital, región, etc.) en los Leads

### 4. Regla de Validación
- No permite cambiar el Owner del Lead a menos que:
  - Esté informado: Country, Lead Source y No. of Employees
  - EXCEPCIONES:
    - El perfil **System Administrator** no necesita completar Country ni No. of Employees
    - El perfil **Contract Manager** no necesita No. of Employees

### 5. Flow (Flujo Automatizado)
- Flow de tipo `Record-Triggered Flow`
- Guarda la fecha actual en el campo personalizado `Owner_Since__c` cuando cambia el Owner del Lead

---

## 🧪 Pruebas

- Clases de test `CountryLayerServiceTest` y `LeadCountryTriggerTest` incluidas
- Prueban la integración y lógica del trigger
- Cobertura mayor al 75% para despliegue

---

## 💾 Despliegue

- Todo el código está en formato metadata compatible con Salesforce DX
- Puede ser desplegado con herramientas como Workbench, VS Code + SFDX, o mediante cambios manuales en el entorno Sandbox

---

## ☁️ Repositorio GitHub

- Este proyecto está disponible en GitHub en este repositorio:
  👉 [https://github.com/Gmm6781/Vass-salesforce-leads-project](https://github.com/Gmm6781/Vass-salesforce-leads-project)