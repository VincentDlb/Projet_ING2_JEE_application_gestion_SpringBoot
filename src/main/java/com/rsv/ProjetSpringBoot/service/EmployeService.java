package com.rsv.ProjetSpringBoot.service;

import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.repository.DepartementRepository;
import com.rsv.ProjetSpringBoot.repository.EmployeRepository;
import com.rsv.ProjetSpringBoot.repository.ProjetRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class EmployeService {

    private final EmployeRepository employeRepository;
    private final ProjetRepository projetRepository;
    private final DepartementRepository departementRepository;

    public EmployeService(EmployeRepository employeRepository, 
                          ProjetRepository projetRepository,
                          DepartementRepository departementRepository) {
        this.employeRepository = employeRepository;
        this.projetRepository = projetRepository;
        this.departementRepository = departementRepository;
    }

    public List<Employe> getAllEmployes() {
        return employeRepository.findAll();
    }

    public Optional<Employe> getEmployeById(Integer id) {
        return employeRepository.findById(id);
    }

    public Employe saveEmploye(Employe employe) {
        // Validation métier possible ici (ex: vérifier email unique si pas géré par BD)
        return employeRepository.save(employe);
    }
    

    public List<Employe> getEmployesByDepartement(Integer departementId) {
        return employeRepository.findByDepartementId(departementId);
    }
    

    /**
     * Filtre les employés selon plusieurs critères combinés.
     * Note: Dans un projet plus avancé, on utiliserait Specification ou QueryDSL.
     * Ici, on filtre en Java (Stream) pour simplifier la migration.
     */
    public List<Employe> filtrerEmployes(Integer departementId, String grade, String poste) {
        List<Employe> tous = employeRepository.findAll();
        
        return tous.stream()
            .filter(e -> {
                // Filtre Département
                if (departementId != null) {
                    if (e.getDepartement() == null || !e.getDepartement().getId().equals(departementId)) {
                        return false;
                    }
                }
                // Filtre Grade
                if (grade != null && !grade.isEmpty()) {
                    if (e.getGrade() == null || !e.getGrade().equals(grade)) {
                        return false;
                    }
                }
                // Filtre Poste
                if (poste != null && !poste.isEmpty()) {
                    if (e.getPoste() == null || !e.getPoste().equals(poste)) {
                        return false;
                    }
                }
                return true;
            })
            .collect(java.util.stream.Collectors.toList());
    }
    
    
    public void deleteEmploye(Integer id) {
        employeRepository.deleteById(id);
    }

    public List<Employe> searchEmployes(String critere, String valeur) {
        switch (critere) {
            case "nom": return employeRepository.findByNomContainingIgnoreCase(valeur);
            case "prenom": return employeRepository.findByPrenomContainingIgnoreCase(valeur);
            case "grade": return employeRepository.findByGrade(valeur);
            case "poste": return employeRepository.findByPosteContainingIgnoreCase(valeur);
            case "matricule": 
                return employeRepository.findByMatricule(valeur)
                        .map(List::of)
                        .orElse(List.of());
            default: return getAllEmployes();
        }
    }
    
    // Logique complexe de modification avec gestion des projets (issue de EmployeServlet)
    public Employe updateEmployeAvecProjets(Employe employeModifie, List<Integer> projetIds) {
        // 1. Sauvegarder les infos de base
        Employe savedEmploye = employeRepository.save(employeModifie);

        // 2. Gérer les projets (Many-to-Many)
        // On récupère tous les projets concernés par les IDs
        if (projetIds != null) {
            // Nettoyer les projets existants si nécessaire ou gérer l'ajout/retrait
            // Avec Spring Data JPA, le plus simple est souvent de laisser le contrôleur
            // gérer l'objet Employe avec ses projets déjà set, ou de faire ceci :
            List<com.rsv.ProjetSpringBoot.model.Projet> projets = projetRepository.findAllById(projetIds);
            
            // Note: La relation est gérée côté Projet (mappedBy="employes" dans Employe)
            // Donc il faut idéalement passer par ProjetService pour ajouter/retirer des membres
            // Ou mettre à jour les projets ici
            for (com.rsv.ProjetSpringBoot.model.Projet p : projets) {
                p.getEmployes().add(savedEmploye);
                projetRepository.save(p);
            }
        }
        return savedEmploye;
    }
}