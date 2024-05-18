package kahitest;

import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import jakarta.servlet.http.Part;
import util.CloudinaryUtil;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.annotation.MultipartConfig;
import java.util.Map;
/**
 *
 * @author FPTSHOP
 */
@MultipartConfig
public class UpdateUserInfo extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("userId");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String birthdayStr = request.getParameter("birthday");
        String address = request.getParameter("address");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String commune = request.getParameter("commune");
        
        
        
       
         Part filePart = request.getPart("avatarUrl");
        
        String avatarUrl = null;
        if (filePart != null && filePart.getSize() > 0) {
            Cloudinary cloudinary = CloudinaryUtil.getCloudinary();
            Map uploadResult = cloudinary.uploader().upload(filePart.getInputStream(), ObjectUtils.emptyMap());
            avatarUrl = (String) uploadResult.get("url");
        }
        
        
        User user = new User();
        user.setUserID(Integer.parseInt(userId)); // 
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setFullname(fullname);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date birthday = null;
        try {
            birthday = dateFormat.parse(birthdayStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        user.setBirthday(birthday);

        user.setAddress(address);
        user.setProvince(province);
        user.setDistrict(district);
        user.setCommune(commune);
        user.setAvatarLink(avatarUrl);
        
        // tao Context Servlet : 
        ServletContext context = getServletContext() ; 
        
        // update user : 
        try { 
            UserDAO.getInstance().updateUser(user, context) ;
        } catch (Exception ex) {
            Logger.getLogger(UpdateUserInfo.class.getName()).log(Level.SEVERE, null, ex);
        }
        // chuyen qua cho thang display thong tin user : 
        request.getRequestDispatcher("handleDisplayUserInfo").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
