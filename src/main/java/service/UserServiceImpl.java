package service;

import dao.UserDAO;
import model.User;
import java.util.List;

public class UserServiceImpl implements UserService {

    private final UserDAO userDAO;

    public UserServiceImpl() {
        this.userDAO = new UserDAO();
    }

    @Override
    public User login(String username, String password) {
        if (username == null || password == null) return null;
        return userDAO.login(username, password);
    }

    @Override
    public boolean register(String username, String password, String email) {
        if (username == null || username.trim().isEmpty())
            throw new ValidationException("Username cannot be empty.");
        if (password == null || password.length() < 3)
            throw new ValidationException("Password must be at least 3 characters.");
        if (email == null || email.trim().isEmpty() || !email.contains("@"))
            throw new ValidationException("A valid email is required.");
        return userDAO.register(username.trim(), password, email.trim());
    }

    @Override
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    @Override
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    @Override
    public User findByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    @Override
    public User findByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    @Override
    public boolean updatePassword(int userId, String newPassword) {
        return userDAO.updatePassword(userId, newPassword);
    }

    @Override
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        User user = userDAO.getUserById(userId);
        if (user != null && user.getPasswordHash().equals(currentPassword)) {
            return userDAO.updatePassword(userId, newPassword);
        }
        return false;
    }

    @Override
    public boolean updateUserProfile(int userId, String fullName, String email, String phone) {
        return userDAO.updateUserProfile(userId, fullName, email, phone);
    }

    @Override
    public boolean updateProfileImage(int userId, String imageUrl) {
        return userDAO.updateProfileImage(userId, imageUrl);
    }
    @Override
    public boolean updateRole(int userId, String role) {
        if (role == null || role.trim().isEmpty())
            throw new ValidationException("Role cannot be empty.");
        return userDAO.updateRole(userId, role);
    }

    @Override
    public boolean createUser(String username, String password, String email, String role) {
        if (username == null || username.trim().isEmpty())
            throw new ValidationException("Username cannot be empty.");
        if (password == null || password.trim().isEmpty())
            throw new ValidationException("Password cannot be empty.");
        if (email == null || email.trim().isEmpty() || !email.contains("@"))
            throw new ValidationException("A valid email is required.");
        return userDAO.createUser(username.trim(), password, email.trim(), role);
    }

    @Override
    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }
}
