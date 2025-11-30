package com.rsv.ProjetSpringBoot.repository;

import com.rsv.ProjetSpringBoot.model.Departement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DepartementRepository extends JpaRepository<Departement, Integer> {

    // Remplace getDepartementByNom
    Optional<Departement> findByNom(String nom);

    // Remplace getDepartementParChef
    Optional<Departement> findByChefDepartementId(Integer chefId);
    
    // Vérifier si un employé est chef (renvoie true si le count > 0)
    boolean existsByIdAndChefDepartementId(Integer id, Integer chefId);
}