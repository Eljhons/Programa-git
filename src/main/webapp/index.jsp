<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*, java.util.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.IOException" %>

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

                String sql = "INSERT INTO usuario (name, age) VALUES (?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, name);
                    pstmt.setInt(2, age);
                    pstmt.executeUpdate();
                    out.println("{\"success\": true, \"message\": \"Registro insertado con éxito.\"}");
                } catch (SQLException e) {
                    out.println("{\"success\": false, \"message\": \"Error al insertar el registro.\"}");
                }
            }
            
            // Operación para eliminar un registro por IDs
            if (request.getParameter("delete") != null) {
                int idToDelete = Integer.parseInt(request.getParameter("delete"));
                String sqlDelete = "DELETE FROM usuario WHERE id=?";
                try (PreparedStatement pstmtDelete = conn.prepareStatement(sqlDelete)) {
                    pstmtDelete.setInt(1, idToDelete);
                    int rowsAffected = pstmtDelete.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("{\"success\": true, \"message\": \"Registro eliminado con éxito.\"}");
                    } else {
                        out.println("{\"success\": false, \"message\": \"No se encontró el registro para eliminar.\"}");
                    }
                } catch (SQLException e) {
                    out.println("{\"success\": false, \"message\": \"Error al eliminar el registro.\"}");
                }
            }
        }

        // Operación para leer todos los registros
        if (request.getMethod().equals("GET")) {
            String sql = "SELECT * FROM usuario";
            try (Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

                List<Map<String, Object>> data = new ArrayList<>();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("name", rs.getString("name"));
                    row.put("age", rs.getInt("age"));
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

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bienvenido a Test7</title>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
</head>
<body>
    <h1>Bienvenido a mi aplicación Test7</h1>

    <!-- Formulario para insertar un nuevo registro -->
    <form id="createForm">
        <label for="name">Nombre:</label>
        <input type="text" id="name" name="name" required>
        <label for="age">Edad:</label>
        <input type="number" id="age" name="age" required>
        <button type="button" onclick="insertRecord()">Insertar</button>
    </form>

    <!-- Formulario para eliminar registros por ID -->
    <form id="deleteForm">
        <label for="deleteId">Eliminar por ID:</label>
        <input type="number" id="deleteId" name="deleteId" required>
        <button type="button" onclick="deleteRecordById()">Eliminar</button>
    </form>

    <!-- Lista para mostrar los registros -->
    <div id="records"></div>

    <!-- Script JavaScript para manejar las operaciones CRUD de manera interactiva -->
    <script>
        // Función para insertar un nuevo registro
        function insertRecord() {
            var name = $("#name").val();
            var age = $("#age").val();
            $.ajax({
                url: "index.jsp",
                type: "POST",
                data: { create: true, name: name, age: age },
                success: function (data) {
                    alert(data.message);
                    loadRecords();
                }
            });
        }

        // Función para eliminar un registro por ID
        function deleteRecordById() {
            var idToDelete = $("#deleteId").val();
            $.ajax({
                url: "index.jsp",
                type: "POST",
                data: { delete: idToDelete },
                success: function (data) {
                    alert(data.message);
                    loadRecords();
                }
            });
        }

        // Función para cargar y mostrar los registros
        function loadRecords() {
            $.ajax({
                url: "index.jsp",
                type: "GET",
                success: function (data) {
                    var recordsDiv = $("#records");
                    recordsDiv.empty();

                    if (data.success) {
                        var records = JSON.parse(data);
                        records.forEach(function (record) {
                            recordsDiv.append("<p>ID: " + record.id + ", Nombre: " + record.name + ", Edad: " + record.age + "</p>");
                        });
                    } else {
                        alert("Error al cargar los registros.");
                    }
                }
            });
        }

        // Cargar registros al cargar la página
        $(document).ready(function () {
            loadRecords();
        });
    </script>
</body>
</html>
