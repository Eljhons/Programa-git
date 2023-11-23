<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*, java.util.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.io.PrintWriter" %>

<%
    // Conexión a la base de datos
    String url = "jdbc:mysql://localhost:3306/test";
    String username = "root";
    String password = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);

        // Verificar la operación solicitada (crear, leer, actualizar o eliminar)
        if (request.getMethod().equals("POST")) {
            // Operación para crear un nuevo registro
            if (request.getParameter("create") != null) {
                String name = request.getParameter("name");
                int age = Integer.parseInt(request.getParameter("age"));

                String sql = "INSERT INTO persona (nombre, edad) VALUES (?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, name);
                    pstmt.setInt(2, age);
                    pstmt.executeUpdate();
                    out.println("{\"success\": true, \"message\": \"Registro insertado con éxito.\"}");
                } catch (SQLException e) {
                    out.println("{\"success\": false, \"message\": \"Error al insertar el registro.\"}");
                }
            }

            // Operación para actualizar un registro existente
            if (request.getParameter("update") != null) {
                int id = Integer.parseInt(request.getParameter("id"));
                String newName = request.getParameter("newName");
                int newAge = Integer.parseInt(request.getParameter("newAge"));

                String sql = "UPDATE persona SET nombre = ?, edad = ? WHERE id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, newName);
                    pstmt.setInt(2, newAge);
                    pstmt.setInt(3, id);
                    pstmt.executeUpdate();
                    out.println("{\"success\": true, \"message\": \"Datos actualizados con éxito.\"}");
                } catch (SQLException e) {
                    out.println("{\"success\": false, \"message\": \"Error al actualizar los datos.\"}");
                }
            }

            // Operación para eliminar un registro
            if (request.getParameter("delete") != null) {
                int id = Integer.parseInt(request.getParameter("id"));

                String sql = "DELETE FROM persona WHERE id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                    out.println("{\"success\": true, \"message\": \"Registro eliminado con éxito.\"}");
                } catch (SQLException e) {
                    out.println("{\"success\": false, \"message\": \"Error al eliminar el registro.\"}");
                }
            }
        }

        // Operación para leer todos los registros
        if (request.getMethod().equals("GET")) {
            String sql = "SELECT * FROM persona";
            try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

                List<Map<String, Object>> data = new ArrayList<>();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("name", rs.getString("nombre"));
                    row.put("age", rs.getInt("edad"));
                    data.add(row);
                }

                out.println(new Gson().toJson(data));
            } catch (SQLException e) {
                out.println("{\"success\": false, \"message\": \"Error al leer los registros.\"}");
            }
        }

        conn.close();
    } catch (ClassNotFoundException | SQLException e) {
        out.println("{\"success\": false, \"message\": \"Conexión fallida.\"}");
    }
%>
