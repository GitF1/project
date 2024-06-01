/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.RouterJSP;
import util.RouterURL;

/**
 *
 * @author duyqu
 */
@WebServlet(name = "AvatarUploadServlet", urlPatterns = {"/avatarUploadServlet"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class AvatarUploadServlet extends HttpServlet {

    private Cloudinary cloudinary;
    RouterURL router = new RouterURL();//IS ROUTER URL, NOT JSP - DuyND
    DAO.UserDAO userDAO;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    public void init(ServletConfig config)
            throws ServletException {
//        super.init();
        super.init(config);
        ServletContext context = config.getServletContext();
        String envFilePath = context.getRealPath("/WEB-INF/config/public/.env");
        Dotenv dotenv = Dotenv.configure().directory(envFilePath).load();

        cloudinary = new Cloudinary(dotenv.get("CLOUDINARY_URL"));
        try {
            userDAO = new DAO.UserDAO(getServletContext());
        } catch (Exception ex) {
            Logger.getLogger(UpdateUserInfo.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AvatarUploadServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AvatarUploadServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);

        ServletContext context = getServletContext();
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        File tempFile = File.createTempFile("upload_", "_" + fileName);
        filePart.write(tempFile.getAbsolutePath());

        try {
            // Upload the file to Cloudinary
            Map<String, Object> uploadParams = ObjectUtils.asMap(
                    "use_filename", true,
                    "unique_filename", false,
                    "overwrite", true,
                    "public_id", username, // Set the desired name for the uploaded image
                    "folder", "user" // Specify the nested folder path
            );

            Map uploadResult = cloudinary.uploader().upload(tempFile, uploadParams);
            String uploadedImageUrl = (String) uploadResult.get("secure_url");
            userDAO.updateAvatarByUsername(username, uploadedImageUrl);
            // Print the uploaded image URL
            response.getWriter().println("Uploaded Image URL: " + uploadedImageUrl);
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        } finally {
            // Clean up the temporary file
            if (tempFile.exists()) {
                tempFile.delete();
            }
        }

//        request.getRequestDispatcher(router.DISPLAY_PROFILE).forward(request, response);
        request.getRequestDispatcher("/handleDisplayUserInfo").forward(request, response);

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
