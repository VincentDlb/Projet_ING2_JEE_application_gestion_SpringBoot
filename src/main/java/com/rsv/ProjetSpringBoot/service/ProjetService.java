package com.rsv.ProjetSpringBoot.service;

import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.model.Projet;
import com.rsv.ProjetSpringBoot.repository.EmployeRepository;
import com.rsv.ProjetSpringBoot.repository.ProjetRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProjetService {

    private final ProjetRepository projetRepository;
    private final EmployeRepository employeRepository;

    public ProjetService(ProjetRepository projetRepository, EmployeRepository employeRepository) {
        this.projetRepository = projetRepository;
        this.employeRepository = employeRepository;
    }

    public List<Projet> getAllProjets() {
        return projetRepository.findAll();
    }
    
    public Optional<Projet> getProjetById(Integer id) {
        return projetRepository.findById(id);
    }

    public Projet saveProjet(Projet projet) {
        return projetRepository.save(projet);
    }

    public void deleteProjet(Integer id) {
        projetRepository.deleteById(id);
    }

    public List<Projet> getProjetsByChef(Integer chefId) {
        return projetRepository.findByChefDeProjetId(chefId);
    }
    
    // Logique "Mes Projets" (Membre ou Chef)
    public List<Projet> getProjetsPourEmploye(Integer employeId) {
        return projetRepository.findProjetsByChefOrMembre(employeId);
    }

    // Gestion des membres d'équipe
    public void ajouterMembre(Integer projetId, Integer employeId) {
        Optional<Projet> projetOpt = projetRepository.findById(projetId);
        Optional<Employe> employeOpt = employeRepository.findById(employeId);

        if (projetOpt.isPresent() && employeOpt.isPresent()) {
            Projet projet = projetOpt.get();
            projet.getEmployes().add(employeOpt.get());
            projetRepository.save(projet);
        }
    }

    public void retirerMembre(Integer projetId, Integer employeId) {
        Optional<Projet> projetOpt = projetRepository.findById(projetId);
        Optional<Employe> employeOpt = employeRepository.findById(employeId);

        if (projetOpt.isPresent() && employeOpt.isPresent()) {
            Projet projet = projetOpt.get();
            projet.getEmployes().remove(employeOpt.get());
            projetRepository.save(projet);
        }
    }
}