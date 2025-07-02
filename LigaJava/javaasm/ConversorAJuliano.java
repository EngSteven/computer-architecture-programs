public class ConversorAJuliano extends javax.swing.JFrame {
    
    private int anio;
    private int mes;
    private int dia;
    private int signo = 0;
    private int resultado;
    private int nDiasPorMes [] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    
    public ConversorAJuliano() {
        initComponents();
    }
    
    //se carga la libreria con los metodos a usar
    static {
        System.loadLibrary("metodos");
    }
    
    public native int calcularJuliano(int a, int b, int c, int s);  //metodo para calcular el dia juliano


    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
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
                                .addGap(22, 22, 22)
                                .addComponent(jLabel2)
                                .addGap(58, 58, 58)
                                .addComponent(jLabel3)
                                .addGap(64, 64, 64)
                                .addComponent(jLabel4))
                            .addComponent(jLabel5))
                        .addContainerGap(172, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jLabelResultado, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jTFAnio, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jTFMes, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(18, 18, 18)
                        .addComponent(jTFDia, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 33, Short.MAX_VALUE)
                        .addComponent(jBCalcular)
                        .addGap(32, 32, 32))))
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                    .addContainerGap(140, Short.MAX_VALUE)
                    .addComponent(jLabel6)
                    .addGap(144, 144, 144)))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(89, 89, 89)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel3)
                    .addComponent(jLabel4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTFAnio, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTFMes, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTFDia, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jBCalcular))
                .addGap(36, 36, 36)
                .addComponent(jLabel5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelResultado, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 17, Short.MAX_VALUE)
                .addComponent(jBRegresar)
                .addGap(32, 32, 32))
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGap(57, 57, 57)
                    .addComponent(jLabel6)
                    .addContainerGap(223, Short.MAX_VALUE)))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jTFAnioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTFAnioActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTFAnioActionPerformed

    private void jTFMesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTFMesActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTFMesActionPerformed

    private void jTFDiaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTFDiaActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTFDiaActionPerformed

    private void jBCalcularActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBCalcularActionPerformed
        // TODO add your handling code here:
        try{                                                //manejo de errores
            anio = Integer.parseInt(jTFAnio.getText());     //se guarda el anio ingresado en el text box
            mes = Integer.parseInt(jTFMes.getText());       //se guarda el mes ingresado en el text box
            dia = Integer.parseInt(jTFDia.getText());       //se guarda el dia ingresado en el text box
            if(mes > 0 && mes <= 12){                       //vericion para ver si el mes esta bien ingresado
                int nDias = nDiasPorMes[mes-1];             //se guardan los nDias que tiene el mes ingresado
                if(anio >= -5777 && anio <= 7777 && anio != 0 && dia > 0 && dia <= nDias){  //se verifica si el anio y dia esta bien ingresado

                    if(anio < 0){                           //en caso de que se ingrese un anio negativo
                        anio *= -1;                         //se transforma a positivo, para poder mandarlo por parametro al asm
                        signo = 1;                          //se coloca el signo en 1 para indicar que el signo es negativo
                    }

                    resultado = calcularJuliano(anio, mes, dia, signo);     //se guarda el resultado, llamando al metodo de ensamblador
                    String resultadoStr = Integer.toString(resultado) + ".5";
                    jLabelResultado.setText(resultadoStr);   //se imprime el resultado 
                }
            }
        }catch(NumberFormatException e){
        }
    }//GEN-LAST:event_jBCalcularActionPerformed

    private void jBRegresarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBRegresarActionPerformed
        // TODO add your handling code here:
        dispose();
        new MenuPrincipal().setVisible(true);
    }//GEN-LAST:event_jBRegresarActionPerformed

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

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jBCalcular;
    private javax.swing.JButton jBRegresar;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabelResultado;
    private javax.swing.JTextField jTFAnio;
    private javax.swing.JTextField jTFDia;
    private javax.swing.JTextField jTFMes;
    // End of variables declaration//GEN-END:variables
}
