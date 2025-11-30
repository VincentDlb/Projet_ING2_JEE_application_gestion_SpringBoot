package com.rsv.ProjetSpringBoot.repository;

import com.rsv.ProjetSpringBoot.model.FicheDePaie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FicheDePaieRepository extends JpaRepository<FicheDePaie, Integer> {

    // Remplace getFichesParEmploye (trié par année et mois décroissant)
    List<FicheDePaie> findByEmployeIdOrderByAnneeDescMoisDesc(Integer employeId);

    // Remplace getFichesParPeriode
    List<FicheDePaie> findByMoisAndAnnee(Integer mois, Integer annee);
}