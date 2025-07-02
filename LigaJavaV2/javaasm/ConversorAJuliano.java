public class ConversorAJuliano extends javax.swing.JFrame {
    
    private int anio = 0;
    private int mes = 0;
    private int dia = 0;
    private int hora = 0;
    private int minutos = 0;
    private int segundos = 0;

    private int signo = 0;
    private int resultado = 0;
    private int decimales = 0;
    private int nDiasPorMes [] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    
    public ConversorAJuliano() {
        initComponents();
    }
    
    //se carga la libreria con los metodos a usar
    static {
        System.loadLibrary("metodos");
    }
    
    public native int calcularJuliano(int anio, int mes, int dia, int signoAnio, int hora);  //metodo para calcular el dia juliano
    public native int calcularDecimalesJulianos(int anio, int mes, int dia, int signoAnio, int hora, int minutos, int segundos);  //metodo para calcular los decimales del dia juliano


    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">                          
    private void initComponents() {

        jLabelResultado = new javax.swing.JLabel();
        jBCalcular = new javax.swing.JButton();
        jTFAnio = new javax.swing.JTextField();
        jTFMes = new javax.swing.JTextField();
        jTFDia = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jBRegresar = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        jTFHora = new javax.swing.JTextField();
        jTFSegundos = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jTFMinutos = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jLabelResultado.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        jBCalcular.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jBCalcular.setText("Calcular");
        jBCalcular.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBCalcularActionPerformed(evt);
            }
        });

        jTFAnio.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFAnio.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFAnioActionPerformed(evt);
            }
        });

        jTFMes.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFMes.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFMesActionPerformed(evt);
            }
        });

        jTFDia.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFDia.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFDiaActionPerformed(evt);
            }
        });

        jLabel2.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel2.setText("Anio");

        jLabel3.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel3.setText("Mes");

        jLabel4.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel4.setText("Dia");

        jLabel5.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel5.setText("Resultado");

        jBRegresar.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jBRegresar.setText("Regresar");
        jBRegresar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBRegresarActionPerformed(evt);
            }
        });

        jLabel6.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel6.setText("Conversor a Juliano");

        jTFHora.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFHora.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFHoraActionPerformed(evt);
            }
        });

        jTFSegundos.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFSegundos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFSegundosActionPerformed(evt);
            }
        });

        jLabel7.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel7.setText("Hora");

        jLabel8.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel8.setText("Segundos");

        jTFMinutos.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFMinutos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFMinutosActionPerformed(evt);
            }
        });

        jLabel9.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel9.setText("Minutos");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(14, 14, 14)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jBRegresar)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                                .addComponent(jLabelResultado, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                .addGroup(layout.createSequentialGroup()
                                                    .addComponent(jTFAnio, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                    .addGap(18, 18, 18)
                                                    .addComponent(jTFMes, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                            .addComponent(jLabel5))
                                        .addGap(18, 18, 18)
                                        .addComponent(jTFDia, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(107, 107, 107))
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                        .addComponent(jLabel7)
                                        .addGap(40, 40, 40)))
                                .addComponent(jTFMinutos, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addGap(22, 22, 22)
                                .addComponent(jLabel2)
                                .addGap(58, 58, 58)
                                .addComponent(jLabel3)
                                .addGap(64, 64, 64)
                                .addComponent(jLabel4)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGap(46, 46, 46)
                                        .addComponent(jTFHora, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addGap(143, 143, 143)
                                        .addComponent(jLabel9)))))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jTFSegundos, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(29, 29, 29)
                                .addComponent(jBCalcular))
                            .addComponent(jLabel8))
                        .addContainerGap(16, Short.MAX_VALUE))))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel6)
                .addGap(265, 265, 265))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(51, 51, 51)
                .addComponent(jLabel6)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jLabel3)
                            .addComponent(jLabel4))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTFAnio, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTFMes, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTFDia, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel7)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTFHora, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jTFMinutos, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel8)
                            .addComponent(jLabel9))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTFSegundos, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jBCalcular))))
                .addGap(36, 36, 36)
                .addComponent(jLabel5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelResultado, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 17, Short.MAX_VALUE)
                .addComponent(jBRegresar)
                .addGap(32, 32, 32))
        );

        pack();
    }// </editor-fold>                        

    private void jTFAnioActionPerformed(java.awt.event.ActionEvent evt) {                                        
    }                                       

    private void jTFMesActionPerformed(java.awt.event.ActionEvent evt) {                                       
    }                                      

    private void jTFDiaActionPerformed(java.awt.event.ActionEvent evt) {                                       
    }                                      

    private void jBCalcularActionPerformed(java.awt.event.ActionEvent evt) {                                           
        
        // TODO add your handling code here:
        try{                                                //manejo de errores
            anio = Integer.parseInt(jTFAnio.getText());     //se guarda el anio ingresado en el text box
            mes = Integer.parseInt(jTFMes.getText());       //se guarda el mes ingresado en el text box
            dia = Integer.parseInt(jTFDia.getText());       //se guarda el dia ingresado en el text box
            hora = Integer.parseInt(jTFHora.getText());       //se guarda la hora ingresado en el text box
            minutos = Integer.parseInt(jTFMinutos.getText());       //se guarda los minutos ingresado en el text box
            segundos = Integer.parseInt(jTFSegundos.getText());       //se guarda los segundos ingresado en el text box
            
            if(mes > 0 && mes <= 12){                       //verificamos el mes 
                int nDias = nDiasPorMes[mes-1];             //se guardan los nDias que tiene el mes ingresado
                //se verifican los demas datos ingresados
                if(
                    anio >= -5777 && anio <= 7777 && anio != 0 
                    && dia > 0 && dia <= nDias 
                    && hora > -1 && hora < 25 
                    && minutos > -1 && minutos < 60 
                    && segundos > -1 && segundos < 60 
                ){  

                    if(anio < 0){                           //en caso de que se ingrese un anio negativo
                        anio *= -1;                         //se transforma a positivo, para poder mandarlo por parametro al asm
                        signo = 1;                          //se coloca el signo en 1 para indicar que el signo es negativo
                    }

                    resultado = calcularJuliano(anio, mes, dia, signo, hora);     //se guarda el resultado, llamando al metodo de ensamblador
                    decimales = calcularDecimalesJulianos(anio, mes, dia, signo, hora, minutos, segundos); //se guardan los decimales desde ensamblador
                    String resultadoStr = Integer.toString(resultado) + "." + Integer.toString(decimales);
                    jLabelResultado.setText(resultadoStr);   //se imprime el resultado 
                }
            }
        }catch(NumberFormatException e){
        }
        
    }                                          

    private void jBRegresarActionPerformed(java.awt.event.ActionEvent evt) {                                           
        dispose();
        new MenuPrincipal().setVisible(true);
    }                                          

    private void jTFHoraActionPerformed(java.awt.event.ActionEvent evt) {                                        
    }                                       

    private void jTFSegundosActionPerformed(java.awt.event.ActionEvent evt) {                                            
    }                                           

    private void jTFMinutosActionPerformed(java.awt.event.ActionEvent evt) {                                           
    }                                          

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(ConversorAJuliano.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ConversorAJuliano.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ConversorAJuliano.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ConversorAJuliano.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ConversorAJuliano().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify                     
    private javax.swing.JButton jBCalcular;
    private javax.swing.JButton jBRegresar;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabelResultado;
    private javax.swing.JTextField jTFAnio;
    private javax.swing.JTextField jTFDia;
    private javax.swing.JTextField jTFHora;
    private javax.swing.JTextField jTFMes;
    private javax.swing.JTextField jTFMinutos;
    private javax.swing.JTextField jTFSegundos;
    // End of variables declaration                   
}
