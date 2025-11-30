package com.rsv.ProjetSpringBoot.service;

import com.rsv.ProjetSpringBoot.model.FicheDePaie;
import com.rsv.ProjetSpringBoot.repository.FicheDePaieRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class FicheDePaieService {

    private final FicheDePaieRepository ficheRepository;

    public FicheDePaieService(FicheDePaieRepository ficheRepository) {
        this.ficheRepository = ficheRepository;
    }

    public List<FicheDePaie> getAllFiches() {
        // On peut trier par défaut ici si le repository ne le fait pas
        return ficheRepository.findAll();
    }

    public Optional<FicheDePaie> getFicheById(Integer id) {
        return ficheRepository.findById(id);
    }

    public List<FicheDePaie> getFichesByEmploye(Integer employeId) {
        return ficheRepository.findByEmployeIdOrderByAnneeDescMoisDesc(employeId);
    }

    public FicheDePaie saveFiche(FicheDePaie fiche) {
        // Logique métier critique : on force le calcul avant sauvegarde
        // Cette méthode calculerTout() est dans ton Entité FicheDePaie (Model)
        fiche.calculerTout(); 
        return ficheRepository.save(fiche);
    }

    public void deleteFiche(Integer id) {
        ficheRepository.deleteById(id);
    }
    
    // Pour RecalculerFichesServlet (Maintenance)
    public void recalculerToutesLesFiches() {
        List<FicheDePaie> fiches = ficheRepository.findAll();
        for (FicheDePaie fiche : fiches) {
            fiche.calculerTout();
            ficheRepository.save(fiche);
        }
    }
    

    public List<FicheDePaie> rechercherFichesAvance(Integer employeId, Integer mois, Integer annee) {
        return ficheRepository.findAll().stream()
            .filter(f -> {
                if (employeId != null && !f.getEmploye().getId().equals(employeId)) return false;
                if (mois != null && !f.getMois().equals(mois)) return false;
                if (annee != null && !f.getAnnee().equals(annee)) return false;
                return true;
            })
            .collect(java.util.stream.Collectors.toList());
    }
    
    public List<FicheDePaie> rechercherFiches(Integer mois, Integer annee) {
        return ficheRepository.findByMoisAndAnnee(mois, annee);
    }
}