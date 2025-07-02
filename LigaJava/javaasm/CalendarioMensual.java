public class CalendarioMensual extends javax.swing.JFrame {
   
    private int nDiasPorMes [] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    private int nDiasAnuales = 365;
    
    public CalendarioMensual() {
        initComponents();
    }

    //funcion para imprimir el calendario mensual
    public void imprimirCalendarioMensual(){
        try{                                                                                    //manejo de errores
            int anio = Integer.parseInt(jTFAnio.getText());                                     //se obtiene el anio ingresado en el text box    
            int mes = Integer.parseInt(jTFMes.getText());                                       //se obtiene el mes ingresado en el text box 
            
            //verica que se haya ingresado todo dentro de los limites
            if(anio >= -5777 && anio <= 7777 && anio != 0 && mes > 0 && mes <= 12){
                if(isLeapYear(anio) == true){
                    nDiasPorMes[1] = 29;
                    nDiasAnuales = 366;
                }

                else if(anio == 1582){
                    nDiasPorMes[9] = 21;
                    nDiasAnuales = 355;
                    if(mes == 10){
                        mesEspecial();
                        return;
                    }
                }

                else{
                    nDiasPorMes[1] = 28;
                    nDiasAnuales = 365;
                }

                int nDias = nDiasPorMes[mes-1];                                                 //se obtiene la cantidad de dias del mes actual                                       
                int signo = 0;                                                                  //se inicia el signo del anio en posivo
                int nDiasPasados = getNDiasPasados(mes);                                        //se obtienen los dias pasados hasta el mes actual
                int nDiasActuales = getNDiasActuales(mes);
                int nSemana = nDiasActuales / 7 + 1;                                             //se obtine el numero de la semana

                if(anio < 0){                                                                   //se verifica si el anio es negativo
                    anio *= -1;                                                                 //se transforma el anio a positivo
                    signo = 1;                                                                  //se pone el signo en negativo 
                }

                int diaJuliano = new ConversorAJuliano().calcularJuliano(anio, mes, 1, signo);  //se se calcula el dia juliano
                int primerDiaMes = new DesplegarCalendario().calcularPrimerDiaMes(diaJuliano);  //se calcula el primer dia del mes
                int columna = primerDiaMes + 1, fila = 0;                                           //inicializa la columna y fila en los lugares correspondientes 
                if(columna == 8){                                                          //verificar ajuste especial de columna
                    columna = 1;
                }

                for(int i = 0; i < nDias; i++){                                 //se recorren los n dias del mes actual
                    if(columna >= 8){                                           //caso maximo de columna
                        columna = 1;                                            //se reinicia la columna en caso de serlo
                        jTableMes.setValueAt(nSemana, fila, 0);                 //se coloca el numero de semana de la fila actual
                        fila ++;                                                //se incrementa la semana para dar un salto de linea
                        nSemana++;                                              
                    }

                    jTableMes.setValueAt(i+1, fila, columna);                   //se coloca el numero del dia de la columna y fila actual
                    columna ++;         
                }
                jTableMes.setValueAt(nSemana, fila, 0);
                jLDiasRestantes.setText(Integer.toString(nDiasPasados));        //se colocan los dias restantes del mes actual
            }
        }catch(NumberFormatException e){

        }
    }
    
    //funcion que limpia el contenido del calendario
    public void limpiarCalendarioMensual(){
        nDiasPorMes[1] = 28;
        nDiasPorMes[9] = 31;
        nDiasAnuales = 365;
        
        for(int i = 0; i < jTableMes.getRowCount(); i ++){          //se conrren las n filas
            for(int j = 0; j < jTableMes.getColumnCount(); j++){    //y las n columnas
                jTableMes.setValueAt(null, i, j);                   //y se colocan en null cada una 
            }
        }
    }

    //obtine los dias que han pasado hasta un mes x
    public int getNDiasPasados(int mes){
        int nDias = nDiasAnuales;
        for(int i = 0; i < mes-1; i++){
            nDias -= nDiasPorMes[i];
        }
        return nDias;
    }

    public static boolean isLeapYear(int year) {
        if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
            return true;
        } else {
            return false;
        }
    }

    public void mesEspecial(){
        int mes = 10;
        int anio = 1582;
        int nDias = nDiasPorMes[mes-1];                                                 //se obtiene la cantidad de dias del mes actual                                       
        int signo = 0;                                                                  //se inicia el signo del anio en posivo
        int nDiasPasados = getNDiasPasados(mes);                                        //se obtienen los dias pasados hasta el mes actual
        int nDiasActuales = getNDiasActuales(mes);
        int nSemana = nDiasActuales / 7 + 1;                                             //se obtine el numero de la semana

        if(anio < 0){                                                                   //se verifica si el anio es negativo
            anio *= -1;                                                                 //se transforma el anio a positivo
            signo = 1;                                                                  //se pone el signo en negativo 
        }

        //int diaJuliano = new ConversorAJuliano().calcularJuliano(anio, mes, 1, signo);  //se se calcula el dia juliano
        int primerDiaMes = 1; 
        
        int columna = primerDiaMes + 1, fila = 0;                                           //inicializa la columna y fila en los lugares correspondientes 
        if(columna == 8){                                                          //verificar ajuste especial de columna
            columna = 1;
        }

        for(int i = 0; i < nDias; i++){                                 //se recorren los n dias del mes actual
            if(columna >= 8){                                           //caso maximo de columna
                columna = 1;                                            //se reinicia la columna en caso de serlo
                jTableMes.setValueAt(nSemana, fila, 0);                 //se coloca el numero de semana de la fila actual
                fila ++;                                                //se incrementa la semana para dar un salto de linea
                nSemana++;                                              
            }
            if(i+1 > 4){
                jTableMes.setValueAt(i+11, fila, columna);
            }
            else{
                jTableMes.setValueAt(i+1, fila, columna);                   //se coloca el numero del dia de la columna y fila actual
            }
            
            columna ++;         
        }
        jTableMes.setValueAt(nSemana, fila, 0);
        jLDiasRestantes.setText(Integer.toString(nDiasPasados));        //se colocan los dias restantes del mes actual
    }

    //obtine los dias que han pasado hasta un mes x
    public int getNDiasActuales(int mes){
        int nDias = 0;
        for(int i = 0; i < mes-1; i++){
            nDias += nDiasPorMes[i];
        }
        return nDias;
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTFMes = new javax.swing.JTextField();
        jTFAnio = new javax.swing.JTextField();
        jBCalcular = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTableMes = new javax.swing.JTable();
        jBLimpiar = new javax.swing.JButton();
        jBRegresar = new javax.swing.JButton();
        jLabel1 = new javax.swing.JLabel();
        jLDiasRestantes = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jTFMes.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFMes.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFMesActionPerformed(evt);
            }
        });

        jTFAnio.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jTFAnio.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFAnioActionPerformed(evt);
            }
        });

        jBCalcular.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jBCalcular.setText("Desplegar");
        jBCalcular.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBCalcularActionPerformed(evt);
            }
        });

        jLabel2.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel2.setText("Anio");

        jLabel3.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel3.setText("Mes");

        jTableMes.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, "", null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null}
            },
            new String [] {
                "semana", "domingo", "lunes", "martes", "miercoles", "jueves", "viernes", "sabado"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jScrollPane1.setViewportView(jTableMes);

        jBLimpiar.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jBLimpiar.setText("Limpiar");
        jBLimpiar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBLimpiarActionPerformed(evt);
            }
        });

        jBRegresar.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jBRegresar.setText("Regresar");
        jBRegresar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBRegresarActionPerformed(evt);
            }
        });

        jLabel1.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        jLabel1.setText("Dias restantes:");

        jLDiasRestantes.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jTFAnio, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jTFMes, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(28, 28, 28)
                        .addComponent(jBCalcular)
                        .addGap(33, 33, 33)
                        .addComponent(jBLimpiar)
                        .addGap(36, 36, 36)
                        .addComponent(jBRegresar))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(22, 22, 22)
                        .addComponent(jLabel2)
                        .addGap(59, 59, 59)
                        .addComponent(jLabel3))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addGap(18, 18, 18)
                        .addComponent(jLDiasRestantes))
                    .addComponent(jScrollPane1))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTFAnio, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTFMes, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jBCalcular)
                    .addComponent(jBLimpiar)
                    .addComponent(jBRegresar))
                .addGap(26, 26, 26)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jLDiasRestantes))
                .addContainerGap(18, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jTFMesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTFMesActionPerformed

    }//GEN-LAST:event_jTFMesActionPerformed

    private void jTFAnioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTFAnioActionPerformed

    }//GEN-LAST:event_jTFAnioActionPerformed

    private void jBCalcularActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBCalcularActionPerformed
        imprimirCalendarioMensual();
    }//GEN-LAST:event_jBCalcularActionPerformed

    private void jBLimpiarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBLimpiarActionPerformed
        // TODO add your handling code here:
        limpiarCalendarioMensual();
    }//GEN-LAST:event_jBLimpiarActionPerformed

    private void jBRegresarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBRegresarActionPerformed
        // TODO add your handling code here:
        dispose();
        new DesplegarCalendario().setVisible(true);
    }//GEN-LAST:event_jBRegresarActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(CalendarioMensual.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(CalendarioMensual.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(CalendarioMensual.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(CalendarioMensual.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new CalendarioMensual().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jBCalcular;
    private javax.swing.JButton jBLimpiar;
    private javax.swing.JButton jBRegresar;
    private javax.swing.JLabel jLDiasRestantes;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTextField jTFAnio;
    private javax.swing.JTextField jTFMes;
    private javax.swing.JTable jTableMes;
    // End of variables declaration//GEN-END:variables
}
