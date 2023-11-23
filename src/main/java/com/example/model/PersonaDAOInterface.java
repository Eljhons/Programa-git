/**
 * 
 */
package com.example.model;

import java.util.List;

public interface PersonaDAOInterface {
    List<Persona> obtenerTodos();
    Persona obtenerPorId(int id);
    void agregarPersona(Persona persona);
    void actualizarPersona(Persona persona);
    void eliminarPersona(int id);
}
