<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Receiving Form - TigerSign</title>
    <link rel="stylesheet" href="../resources/css/totp.css">
    <link rel="icon" href="../resources/images/tigersign.png" type="image/x-icon">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.0/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.12/cropper.min.css" rel="stylesheet">
    <script>
    document.addEventListener("DOMContentLoaded", function() {
        var images = [];
        
        // Add images from background1.jpg to background15.jpg
        for (var i = 1; i <= 10; i++) {
            images.push("../resources/images/background" + i + ".JPG");
        }
        
        // Select a random image
        var randomImage = images[Math.floor(Math.random() * images.length)];
        
        // Set the selected image as the background
        document.body.style.backgroundImage = "url('" + randomImage + "')";
    });
</script>
</head>
<style>
    .success-checkmark {
    width: 163.2px;
    height: 234.6px;
    margin: 0 auto;

    .check-icon {
        width: 163.2px;
        height: 163.2px;
        position: relative;
        border-radius: 50%;
        box-sizing: content-box;
        border: 8.16px solid #4CAF50;
        left: 50%; /* Center horizontally */
        transform: translateX(-50%); /* Shift back half of its width */
        
        &::before {
            top: 6.12px;
            left: -4.08px;
            width: 61.2px;
            transform-origin: 100% 50%;
            border-radius: 100px 0 0 100px;
        }
        
        &::after {
            top: 0;
            left: 61.2px;
            width: 122.4px;
            transform-origin: 0 50%;
            border-radius: 0 100px 100px 0;
            animation: rotate-circle 4.25s ease-in;
        }
        
        &::before, &::after {
            content: '';
            height: 204px;
            position: absolute;
            background: #FFFFFF;
            transform: rotate(-45deg);
        }
        
        .icon-line {
            height: 10.2px;
            background-color: #4CAF50;
            display: block;
            border-radius: 4px;
            position: absolute;
            z-index: 10;
            
            &.line-tip {
                top: 93.84px;
                left: 28.56px;
                width: 51px;
                transform: rotate(45deg);
                animation: icon-line-tip 0.75s;
            }
            
            &.line-long {
                top: 77.52px;
                right: 16.32px;
                width: 95.88px;
                transform: rotate(-45deg);
                animation: icon-line-long 0.75s;
            }
        }
        
        .icon-circle {
            top: -8.16px;
            left: -8.16px;
            z-index: 10;
            width: 163.2px;
            height: 163.2px;
            border-radius: 50%;
            position: absolute;
            box-sizing: content-box;
            border: 8.16px solid rgba(76, 175, 80, .5);
        }
        
        .icon-fix {
            top: 16.32px;
            width: 10.2px;
            left: 53.04px;
            z-index: 1;
            height: 173.4px;
            position: absolute;
            transform: rotate(-45deg);
            background-color: #FFFFFF;
        }
    }
}

@keyframes rotate-circle {
    0% {
        transform: rotate(-45deg);
    }
    5% {
        transform: rotate(-45deg);
    }
    12% {
        transform: rotate(-405deg);
    }
    100% {
        transform: rotate(-405deg);
    }
}

@keyframes icon-line-tip {
    0% {
        width: 0;
        left: 2.04px;
        top: 38.76px;
    }
    54% {
        width: 0;
        left: 2.04px;
        top: 38.76px;
    }
    70% {
        width: 102px;
        left: -16.32px;
        top: 77.52px;
    }
    84% {
        width: 34.56px;
        left: 42.84px;
        top: 97.92px;
    }
    100% {
        width: 51px;
        left: 28.56px;
        top: 91.8px;
    }
}

@keyframes icon-line-long {
    0% {
        width: 0;
        right: 93.84px;
        top: 110.16px;
    }
    65% {
        width: 0;
        right: 93.84px;
        top: 110.16px;
    }
    84% {
        width: 112.2px;
        right: 0px;
        top: 71.4px;
    }
    100% {
        width: 95.88px;
        right: 16.32px;
        top: 77.52px;
    }
}

#countdownText {
        text-align: center;
        font-size: 14px; 
        color: gray;     
        margin-top: 20px; 
    }
</style>
<body>
    <header>
        <div class="logo">
            <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="TigerSign Logo">
        </div>
    </header>
    <div class="form-box-success">
        <div class="highlight-bar"></div>
        <div class="form-details">
            <h1 class="title-sucess">DOCUMENT RECEIVING FORM SUBMITTED</h1>
            <div class="success-checkmark">
                <div class="check-icon">
                  <span class="icon-line line-tip"></span>
                  <span class="icon-line line-long"></span>
                  <div class="icon-circle"></div>
                  <div class="icon-fix"></div>
                </div>
            </div>

            <div class="success-text">
                <i class="bi bi-info-circle"></i>
                <p>A <strong>Survey Evaluation Form</strong> will be sent to the Email Address you provided in the Document Receiving Form. 
                Your response will be highly appreciated for the improvement of our service. Thank you!</p>
            </div>
            
            <div id="countdownText">
                Redirecting back to Dashboard in: <span id="countdown">10</span>s
            </div>
        </div>
    </div>
    
    <script>
        var countdownElement = document.getElementById("countdown");
        var countdownValue = 10;

        var countdownInterval = setInterval(function() {
            countdownValue--;
            countdownElement.textContent = countdownValue;

            if (countdownValue <= 0) {
                clearInterval(countdownInterval);
                window.close();
            }
        }, 1000); 
    </script>
</body>

</html>