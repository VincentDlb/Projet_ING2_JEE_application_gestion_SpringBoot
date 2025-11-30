package com.rsv.ProjetSpringBoot.service;

import com.rsv.ProjetSpringBoot.model.Employe;
import com.rsv.ProjetSpringBoot.model.User;
import com.rsv.ProjetSpringBoot.repository.EmployeRepository;
import com.rsv.ProjetSpringBoot.repository.UserRepository;
import com.rsv.ProjetSpringBoot.util.PasswordUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final EmployeRepository employeRepository; // Ajout nécessaire

    public UserService(UserRepository userRepository, EmployeRepository employeRepository) {
        this.userRepository = userRepository;
        this.employeRepository = employeRepository;
    }

    // Modification de la méthode pour prendre le matricule
    public User inscription(User user, String matricule) throws Exception {
        
        // 1. Trouver l'employé par matricule
        Optional<Employe> employeOpt = employeRepository.findByMatricule(matricule);
        if (employeOpt.isEmpty()) {
            throw new Exception("Aucun employé trouvé avec le matricule " + matricule);
        }
        Employe employe = employeOpt.get();

        // 2. Vérifier si l'employé a déjà un compte
        if (userRepository.findByEmployeId(employe.getId()).isPresent()) {
            throw new Exception("Cet employé possède déjà un compte utilisateur.");
        }
        
        // 3. Vérifier si le username existe déjà
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new Exception("Ce nom d'utilisateur est déjà pris.");
        }

        // 4. Assigner les données manquantes
        user.setEmploye(employe);
        user.setDepartement(employe.getDepartement());
        user.setNomComplet(employe.getNom() + " " + employe.getPrenom());
        
        // --- C'EST ICI QUE TU CORRIGES L'ERREUR ---
        user.setRole("EMPLOYE"); // Rôle par défaut
        // -------------------------------------------

        // 5. Hacher le mot de passe
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);

        return userRepository.save(user);
    }

    public User login(String username, String rawPassword) {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (PasswordUtil.checkPassword(rawPassword, user.getPassword())) {
                return user;
            }
        }
        return null;
    }
    
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
}