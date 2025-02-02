class EmailConfig {
  static const String gmailEmail = "tchindebebruno@gmail.com";
  static const String gmailPassword = "ggdn yycz pvlf uhcz";
  static const String emailApiKey = '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';
  static String subjectAccountCreated = 'Account created 🎉';
  static String testAvailable = 'Test Results Available 🎉';
  static String contentMailAccountCreated(String candidateEmail, String candidatePassword) => '''
 <!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Account Creation</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f9;
      margin: 0;
      padding: 0;
      color: #333333;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background: #ffffff;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    .header {
      background-color: #007BFF;
      color: #ffffff;
      text-align: center;
      padding: 20px;
      font-size: 20px;
    }
    .content {
      padding: 20px;
      line-height: 1.6;
    }
    .footer {
      background-color: #f4f4f9;
      color: #555555;
      text-align: center;
      padding: 10px;
      font-size: 12px;
    }
    .credentials {
      background-color: #f9f9f9;
      padding: 15px;
      border: 1px solid #dddddd;
      border-radius: 5px;
      margin-top: 10px;
    }
    .credentials p {
      margin: 5px 0;
    }
    a {
      color: #007BFF;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      License Driving App
    </div>
    <div class="content">
      <p>Hello,</p>
      <p>Your account has been successfully created in the application.</p>
      <p>Here are your login credentials to access the application:</p>
      <div class="credentials">
        <p><strong>Email:</strong> $candidateEmail</p>
        <p><strong>Password:</strong> $candidatePassword</p>
      </div>
      <p>You will be able to view your test results as soon as they are available.</p>
      <p>Thank you,</p>
      <p><strong>License Driving App</strong></p>
    </div>
    <div class="footer">
      &copy; 2025 License Driving App. All rights reserved.
    </div>
  </div>
</body>
</html>
''';
  static String contentMailTestCreated = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Test Results Notification</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f9;
      margin: 0;
      padding: 0;
      color: #333333;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background: #ffffff;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    .header {
      background-color: #007BFF;
      color: #ffffff;
      text-align: center;
      padding: 20px;
      font-size: 20px;
    }
    .content {
      padding: 20px;
      line-height: 1.6;
    }
    .cta {
      margin: 20px 0;
      text-align: center;
    }
    .cta a {
      display: inline-block;
      background-color: #007BFF;
      color: #ffffff;
      padding: 10px 20px;
      border-radius: 5px;
      text-decoration: none;
      font-size: 16px;
      font-weight: bold;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    .cta a:hover {
      background-color: #0056b3;
    }
    .footer {
      background-color: #f4f4f9;
      color: #555555;
      text-align: center;
      padding: 10px;
      font-size: 12px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      License Driving App
    </div>
    <div class="content">
      <p>Hello,</p>
      <p>Your test results are now available in the application.</p>
      <p>You can view them by logging in using the credentials sent in the previous email.</p>
      <p>If you haven’t downloaded the app yet, you can do so using the link below:</p>
      <div class="cta">
        <a href="#">Download the app on the App Store</a>
      </div>
      <p>Thank you,</p>
      <p><strong>License Driving App</strong></p>
    </div>
    <div class="footer">
      &copy; 2025 License Driving App. All rights reserved.
    </div>
  </div>
</body>
</html>

''';

}