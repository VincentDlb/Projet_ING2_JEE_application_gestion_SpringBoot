package com.rsv.ProjetSpringBoot.repository;

import com.rsv.ProjetSpringBoot.model.Employe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmployeRepository extends JpaRepository<Employe, Integer> {

    // Remplace rechercherParMatricule
    Optional<Employe> findByMatricule(String matricule);

    // Remplace rechercherParNom (avec recherche partielle et insensible à la casse)
    List<Employe> findByNomContainingIgnoreCase(String nom);

    // Remplace rechercherParPrenom
    List<Employe> findByPrenomContainingIgnoreCase(String prenom);

    // Remplace listerParDepartement
    List<Employe> findByDepartementId(Integer departementId);

    // Remplace listerParGrade
    List<Employe> findByGrade(String grade);

    // Remplace listerParPoste
    List<Employe> findByPosteContainingIgnoreCase(String poste);

    // --- Pour les statistiques (Remplace des parties de StatistiquesDAO) ---
    
    // Total masse salariale
    @Query("SELECT COALESCE(SUM(e.salaire), 0.0) FROM Employe e")
    Double sumMasseSalariale();

    // Salaire moyen
    @Query("SELECT COALESCE(AVG(e.salaire), 0.0) FROM Employe e")
    Double avgSalaire();
    
    // Salaire Min
    @Query("SELECT COALESCE(MIN(e.salaire), 0.0) FROM Employe e")
    Double minSalaire();
    
    // Salaire Max
    @Query("SELECT COALESCE(MAX(e.salaire), 0.0) FROM Employe e")
    Double maxSalaire();
}