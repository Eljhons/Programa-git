// PersonaDAO.java
package com.example.model;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class PersonaDAO implements PersonaDAOInterface {

    @Override
    public List<Persona> obtenerTodos() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Persona", Persona.class).list();
        }
    }

    @Override
    public Persona obtenerPorId(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Persona.class, id);
        }
    }

    @Override
    public void agregarPersona(Persona persona) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            Object save = session.save(persona);
            transaction.commit();
        }
    }

    @Override
    public void actualizarPersona(Persona persona) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            session.update(persona);
            transaction.commit();
        }
    }

    @Override
    public void eliminarPersona(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction transaction = session.beginTransaction();
            Persona persona = session.get(Persona.class, id);
            if (persona != null) {
                session.delete(persona);
            }
            transaction.commit();
        }
    }
}
