package com.rsv.ProjetSpringBoot.service;

import com.rsv.ProjetSpringBoot.model.Statistiques;
import com.rsv.ProjetSpringBoot.repository.DepartementRepository;
import com.rsv.ProjetSpringBoot.repository.EmployeRepository;
import com.rsv.ProjetSpringBoot.repository.FicheDePaieRepository;
import com.rsv.ProjetSpringBoot.repository.ProjetRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class StatistiquesService {

    private final EmployeRepository employeRepository;
    private final DepartementRepository departementRepository;
    private final ProjetRepository projetRepository;
    private final FicheDePaieRepository ficheDePaieRepository;

    public StatistiquesService(EmployeRepository employeRepository, 
                               DepartementRepository departementRepository,
                               ProjetRepository projetRepository, 
                               FicheDePaieRepository ficheDePaieRepository) {
        this.employeRepository = employeRepository;
        this.departementRepository = departementRepository;
        this.projetRepository = projetRepository;
        this.ficheDePaieRepository = ficheDePaieRepository;
    }

    public Statistiques getStatistiquesGlobales() {
        Statistiques stats = new Statistiques();
        
        // Totaux
        stats.setTotalEmployes((int) employeRepository.count());
        stats.setTotalDepartements((int) departementRepository.count());
        stats.setTotalProjets((int) projetRepository.count());
        stats.setTotalFichesDePaie((int) ficheDePaieRepository.count());

        // Salaires
        stats.setMasseSalarialeTotal(employeRepository.sumMasseSalariale());
        stats.setSalaireMoyen(employeRepository.avgSalaire());
        stats.setSalaireMin(employeRepository.minSalaire());
        stats.setSalaireMax(employeRepository.maxSalaire());
        
        return stats;
    }

    // Remplace la logique spécifique du DAO pour un département
    public Map<String, Object> getStatistiquesDepartement(Integer departementId) {
        Map<String, Object> stats = new HashMap<>();
        
        // On réutilise le repository Employe pour filtrer
        List<com.rsv.ProjetSpringBoot.model.Employe> employes = employeRepository.findByDepartementId(departementId);
        
        stats.put("nombreEmployes", employes.size());
        
        double masseSalariale = employes.stream()
                .mapToDouble(com.rsv.ProjetSpringBoot.model.Employe::getSalaire)
                .sum();
        stats.put("masseSalariale", masseSalariale);
        
        // Note: Pour la répartition par grade, on pourrait le faire en Java ici
        // ou ajouter une requête spécifique dans le Repository.
        
        return stats;
    }

    // Remplace la logique spécifique du DAO pour un projet
    public Map<String, Object> getStatistiquesProjet(Integer projetId) {
        Map<String, Object> stats = new HashMap<>();
        
        return projetRepository.findById(projetId).map(projet -> {
            stats.put("nombreEmployes", projet.getEmployes().size());
            return stats;
        }).orElse(stats);
    }
}