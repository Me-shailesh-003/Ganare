<%-- 
    Document   : update_password
    Created on : 21-Jan-2024, 9:56:31 pm
    Author     : hp
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Password</title>
       
         <style>
        body {
          
            margin-top: 10%;
            padding: 0;
            background-color: #130444;
        }

        .container {
            
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        .upd_pwd {
            width: 50%;
            
            padding-left: 10vw;
        }

        h4 {
            padding-left: 50px;
            font-family: Arial, sans-serif;
            color: #010910;
        }

        form {
            padding-top: 30px;
            max-width: 100%;
            padding-bottom: 30px;
        }

        label {
            display: block;
            margin-top: 10px;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #050101;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            margin-top: 10px;
            background-color: #040e1a;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }

        button:hover {
            background-color: #130444;
            
            
        }
    </style>
   
    </head>
    <body>
     
        <%
           String email=request.getParameter("mail");
            %>
        
    <div class="container">
        
        <div class="upd_pwd">
            <h4> Update your password </h4>
            <form action="Update_Password" method="post">
           <label for="pwd1"> Password: </label>
           <input type="password" name="pwd" id="pwd1" placeholder="Enter new password" required>

           <label for="pwd2">  Confirm Password: </label>
           <input type="password"   id="pwd2" placeholder="Enter confirm password" required>
           <span id="one" style=" margin-left: 12px; padding-bottom: 10px; color:red"></span>
            <input type="hidden" name="mail" value="<%=email%>">
           
           <button type="submit" onclick="return valid()" >Update Password</button>
            </form>
        </div>  
    </div>
            
   <script>
function valid()
{
pwd1=document.getElementById("pwd1").value;
pwd2=document.getElementById("pwd2").value;

if(pwd1==pwd2)
{
return true;
}
else
{
document.getElementById("one").innerHTML="Password and confirm password not match";
return false;
}

}
</script>         
            
     
</body>
</html>

            