/**
 * 
 */
package com.example.model;

import java.text.SimpleDateFormat;
import java.sql.Timestamp;

public class Utilidades {
    public static String formatDate(Timestamp timestamp) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(timestamp);
    }
}
