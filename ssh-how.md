## 1. Configurar NixOS para SSH
Debes asegurarte de que NixOS gestione el agente SSH para que tus llaves se guarden en memoria durante la sesión. Edita tu archivo /etc/nixos/configuration.nix y añade las siguientes líneas según sea necesario:
- Habilitar el agente SSH: Para que el sistema recuerde tus contraseñas de llave, activa la opción programs.ssh.startAgent = true;.
- Servidor SSH (Opcional): Si también necesitas acceder a tu máquina NixOS de forma remota, puedes revisar la guía de SSH en la Nix Wiki para habilitar el servicio básico con services.openssh.enable = true;.
- Aplicar cambios: Ejecuta sudo nixos-rebuild switch para aplicar la configuración.
  
## 2. Generar y agregar la llave a GitHub
Una vez configurado el sistema, sigue estos pasos manuales (ya que las llaves privadas son secretos que no deben estar en el "nix store" público):
1. Generar la llave: Usa el comando ssh-keygen -t ed25519 -C "tu_email@ejemplo.com" en la terminal.
2. Añadir al agente: Si usas una contraseña para la llave, agrégala al agente con ssh-add ~/.ssh/id_ed25519.
3. Vincular con GitHub:
   1. Copia tu llave pública: cat ~/.ssh/id_ed25519.pub.
   2. Ve a la configuración de tu cuenta en la [página oficial de GitHub](https://github.com/settings/keys) y añade una "New SSH Key" pegando el contenido copiado.
   3. Alternativamente, puedes usar el comando gh ssh-key add ~/.ssh/id_ed25519.pub si tienes instalada la herramienta de línea de comandos de GitHub.
      
## 3. Verificar la conexión
Para confirmar que todo funciona correctamente, ejecuta:
```bash
ssh -T git@github.com
```
