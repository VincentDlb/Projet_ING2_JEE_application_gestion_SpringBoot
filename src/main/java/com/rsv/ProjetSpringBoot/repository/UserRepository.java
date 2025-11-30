package com.rsv.ProjetSpringBoot.repository;

import com.rsv.ProjetSpringBoot.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    // Remplace getUserByUsername
    Optional<User> findByUsername(String username);

    // Remplace getUserByEmployeId
    Optional<User> findByEmployeId(Integer employeId);
    
    // Pour vérifier la connexion facilement
    Optional<User> findByUsernameAndPassword(String username, String password);
}