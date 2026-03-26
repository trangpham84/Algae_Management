package service;

import model.User;
import java.util.List;

public interface UserService {

    User login(String username, String password);

    boolean register(String username, String password, String email);

    User getUserById(int userId);

    List<User> getAllUsers();

    User findByUsername(String username);

    User findByEmail(String email);

    boolean updatePassword(int userId, String newPassword);

    boolean changePassword(int userId, String currentPassword, String newPassword);

    boolean updateUserProfile(int userId, String fullName, String email, String phone);

    boolean updateProfileImage(int userId, String imageUrl);

    boolean updateRole(int userId, String role);

    boolean createUser(String username, String password, String email, String role);

    boolean deleteUser(int userId);
}
