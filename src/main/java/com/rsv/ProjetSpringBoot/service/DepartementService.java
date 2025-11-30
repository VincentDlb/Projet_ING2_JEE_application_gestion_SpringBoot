package com.rsv.ProjetSpringBoot.service;

import com.rsv.ProjetSpringBoot.model.Departement;
import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.repository.DepartementRepository;
import com.rsv.ProjetSpringBoot.repository.EmployeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DepartementService {

    private final DepartementRepository departementRepository;
    private final EmployeRepository employeRepository;

    public DepartementService(DepartementRepository departementRepository, EmployeRepository employeRepository) {
        this.departementRepository = departementRepository;
        this.employeRepository = employeRepository;
    }

    public List<Departement> getAllDepartements() {
        return departementRepository.findAll();
    }

    public Optional<Departement> getDepartementById(Integer id) {
        return departementRepository.findById(id);
    }

    public Departement saveDepartement(Departement departement) {
        return departementRepository.save(departement);
    }

    public void deleteDepartement(Integer id) {
        // Attention: gérer les employés liés avant suppression si nécessaire
        // (Set departement_id à null pour les employés de ce département)
        List<Employe> employes = employeRepository.findByDepartementId(id);
        for (Employe e : employes) {
            e.setDepartement(null);
            employeRepository.save(e);
        }
        departementRepository.deleteById(id);
    }
    
    public Optional<Departement> getDepartementByChef(Integer chefId) {
        return departementRepository.findByChefDepartementId(chefId);
    }

    // Gestion des membres (MonDepartementServlet)
    public void ajouterMembre(Integer departementId, Integer employeId) {
        Optional<Departement> dept = departementRepository.findById(departementId);
        Optional<Employe> emp = employeRepository.findById(employeId);

        if (dept.isPresent() && emp.isPresent()) {
            Employe e = emp.get();
            e.setDepartement(dept.get());
            employeRepository.save(e);
        }
    }

    public void retirerMembre(Integer employeId) {
        Optional<Employe> emp = employeRepository.findById(employeId);
        if (emp.isPresent()) {
            Employe e = emp.get();
            e.setDepartement(null);
            employeRepository.save(e);
        }
    }
}