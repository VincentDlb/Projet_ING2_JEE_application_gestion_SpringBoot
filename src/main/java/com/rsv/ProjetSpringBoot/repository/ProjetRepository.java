package com.rsv.ProjetSpringBoot.repository;

import com.rsv.ProjetSpringBoot.model.Projet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProjetRepository extends JpaRepository<Projet, Integer> {

    // Remplace listerParEtat
    List<Projet> findByEtat(String etat);

    // Remplace listerProjetsParChef
    List<Projet> findByChefDeProjetId(Integer chefId);

    // Remplace verifierEstChefProjet
    boolean existsByIdAndChefDeProjetId(Integer projetId, Integer chefId);

    // Remplace listerProjetsByEmploye (Projets où l'employé est membre)
    // Spring gère le ManyToMany automatiquement via le mot clé "EmployesId"
    List<Projet> findByEmployesId(Integer employeId);

    // Remplace listerTousMesProjets (Chef OU Membre)
    @Query("SELECT DISTINCT p FROM Projet p LEFT JOIN p.employes e " +
           "WHERE p.chefDeProjet.id = :employeId OR e.id = :employeId")
    List<Projet> findProjetsByChefOrMembre(@Param("employeId") Integer employeId);
}