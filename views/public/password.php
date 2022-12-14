<?php
// Se incluye la clase con las plantillas del documento.
require_once('../../app/helpers/public_page.php');
// Se imprime la plantilla del encabezado enviando el título de la página web.
Public_Page::headerTemplate('Cambio de clave','public');
?>
    <head>  <!-- Manda a llamar el css de la pagina -->
        <link type="text/css" rel="stylesheet" href="../../resources/css/styles.css" />
    </head>                                                                                                                                                                                                                                         <br>
    <h3 class="center-align">Actualización de contraseña</h3><br>
    <!-- Formulario para registrar al primer usuario del dashboard -->
    <form method="post" id="session-form">
        <div class="row">
            <?php 
       

            print'
                <div class="input-field offset-s3 col s6">
                    <i class="material-icons prefix ">person_pin</i>
                    <input id="alias" type="text" name="alias" autocomplete="off" value="'.$_SESSION['mail']. '" class="validate" required disabled />
                    <label for="alias">Correo electrónico</label>
                </div>

                <div class="input-field offset-s3 col s6">
                    <i class="material-icons prefix ">do_not_disturb</i>
                    <input id="clave" type="password" name="alias" autocomplete="off" value="'.$_SESSION['clave'].'" class="validate" required disabled />
                    <label for="clave">Clave antigua</label>
                </div>
                <div id="xd" class="col s2"><br><br>
                    <a onclick="mostrarClave()"><i class="material-icons">visibility</i></a>
                </div>


                ';

        
            ?>
            <div class="input-field offset-s3 col s6">
                <i class="material-icons prefix">security</i>
                <input id="clave1" type="password" name="clave1" autocomplete="off" class="validate" />
                <label for="clave1">Clave</label>
                <span class="helper-text">Tu nueva debe ser diferente a la clave actual.</span>

            </div>
            <div class="input-field offset-s3 col s6">
                <i class="material-icons prefix">security</i>
                <input id="clave2" type="password" name="clave2" autocomplete="off" class="validate"  />
                <label for="clave2">Confirmar clave</label>
                <span class="helper-text">Debe confirmar su nueva clave.</span>
            </div>
        </div>
        </form>
        <div class="row">
            <div class="col l7 m7 push-m5 push-l5 s7 push-s3">
                <button onclick="cambiarClave2()" class="button2"><i class="material-icons">cached</i> Actualizar clave</button>
            </div>
        </div>
    
    <?php
// Se imprime la plantilla del pie enviando el nombre del controlador para la página web.
Public_Page::footerTemplate('password.js');
?>