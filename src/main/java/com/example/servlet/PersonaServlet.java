// PersonaServlet.java
package com.example.servlet;

import com.example.model.Persona;
import com.example.model.PersonaDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/persona")
public class PersonaServlet extends HttpServlet {

    private PersonaDAO personaDAO;

    @Override
    public void init() throws ServletException {
        personaDAO = new PersonaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementa la lógica para manejar solicitudes GET aquí
        // Por ejemplo, obtener todas las personas y enviarlas como respuesta
        List<Persona> personas = personaDAO.obtenerTodos();
        // Puedes usar request.setAttribute() para pasar datos al JSP o response.getWriter() para enviar directamente la respuesta.
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementa la lógica para manejar solicitudes POST aquí
        // Por ejemplo, agregar una nueva persona a la base de datos
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementa la lógica para manejar solicitudes PUT aquí
        // Por ejemplo, actualizar la información de una persona en la base de datos
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementa la lógica para manejar solicitudes DELETE aquí
        // Por ejemplo, eliminar una persona de la base de datos
    }
}
