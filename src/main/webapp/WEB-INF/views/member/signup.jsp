<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
	<my:navBar active="signup"></my:navBar>
	
	<div class="container-md">
		<div class="row">
			<div class="col">
				<h1>회원가입</h1>
				
				<form action="" method="post">
					<div class="mb-3">
						<label for="" class="form-label">
							아이디
						</label>
						
						<div class="input-group">
							<input id="userIdInput1" class="form-control" type="text" name="id">
							<button id="userIdExistButton1" class="btn btn-outline-secondary" type="button">중복확인</button>
						</div>
						
						<div id="userIdText1" class="form-text">아이디 중복확인을 해주세요.</div>
						
					</div>
					
					<div class="mb-3">
						<label for="" class="form-label">
							별명
						</label>
						
						<div class="input-group">
							<input id="nickNameInput1" class="form-control" type="text" name="nickName">
							<button id="nickNameExistButton1" class="btn btn-outline-secondary" type="button">중복확인</button>
						</div>
						
						<div id="nickNameText1" class="form-text">별명 중복확인을 해주세요.</div>
						
					</div>

					<div class="mb-3">
						<label for="" class="form-label">
							암호
						</label>
						<input id="passwordInput1" class="form-control" type="text" name="password">
						<div id="passwordText1" class="form-text"></div>
					</div>
					
					<div class="mb-3">
						<label for="" class="form-label">
							암호 확인
						</label>
						<input id="passwordInput2" class="form-control" type="text">
					</div>

					<div class="mb-3">
						<label for="" class="form-label">
						이메일
						</label>
						
						<div class="input-group">
							<input id="emailInput1" class="form-control" type="email" name="email">
							<button id="emailExistButton1" type="button" class="btn btn-outline-secondary">중복확인</button>
						</div>
						
						<div id="emailText1" class="form-text">이메일 중복확인을 해주세요.</div>
					</div>

					<input disabled id="submitButton1" class="btn btn-primary" type="submit" value="가입">
				
				</form>
			</div>
		</div>
	</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>

<script>
const ctx = "${pageContext.request.contextPath}";
// 아이디 사용 가능
let availableId = false;
// 이메일 사용 가능
let availableEmail = false;
// 패스워드 사용 가능
let availablePassword = false;
// 별명 사용 가능
let availableNickName = false;

function enableSubmitButton() {
	const button = document.querySelector("#submitButton1");
	if (availableId && availableEmail && availablePassword && availableNickName) {
		button.removeAttribute("disabled")
	} else {
		button.setAttribute("disabled", "");
	}
}

//id input 변경시 submit 버튼 비활성화
document.querySelector("#userIdInput1").addEventListener("keyup", function() {
	availableId = false;
	enableSubmitButton();
});

// 이메일 input 변경시 submit 버튼 비활성화
document.querySelector("#emailInput1").addEventListener("keyup", function() {
	availableEmail = false;
	enableSubmitButton();
});


// 이메일 중복확인
document.querySelector("#emailExistButton1").addEventListener("click", function() {
	availableEmail = false;
	const email = document.querySelector("#emailInput1").value;
	
	fetch(`\${ctx}/member/existEmail`, {
		method : "post",
		headers : {
			"Content-Type" : "application/json"
		},
		body : JSON.stringify({email})
	})
		.then(res => res.json())
		.then(data => {
			document.querySelector("#emailText1").innerText = data.message;
			
			if (data.status == "not exist") {
				availableEmail = true;
				enableSubmitButton();
			}
		});
});

// 아이디 중복확인
document.querySelector("#userIdExistButton1").addEventListener("click", function() {
	availableId = false;
	// 입력된 userId를
	const userId = document.querySelector("#userIdInput1").value;
	
	// fetch 요청 보내고
	fetch(ctx + "/member/existId/" + userId)
		.then(res => res.json())
		.then(data => {
			// 응답 받아서 메세지 출력
			document.querySelector("#userIdText1").innerText = data.message;
			
			if (data.status == "not exist") {
				availableId = true;
				enableSubmitButton();
			}
		}); 
	
});

//별명 중복확인
document.querySelector("#nickNameExistButton1").addEventListener("click", function() {
	availableNickName = false;
	// 입력된 별명을
	const userId = document.querySelector("#nickNameInput1").value;
	
	// fetch 요청 보내고
	fetch(ctx + "/member/existNickName/" + userId)
		.then(res => res.json())
		.then(data => {
			// 응답 받아서 메세지 출력
			document.querySelector("#nickNameText1").innerText = data.message;
			
			if (data.status == "not exist") {
				availableNickName = true;
				enableSubmitButton();
			}
		}); 
	
});



/* 패스워드 일치하는 지 확인 시작 */
const passwordInput1 = document.querySelector("#passwordInput1");
const passwordInput2 = document.querySelector("#passwordInput2");
const passwordText1 = document.querySelector("#passwordText1");

function matchPassword() {
	availablePassword = false;
	
	const value1 = passwordInput1.value;
	const value2 = passwordInput2.value;
	
	if (value1 == value2) {
		passwordText1.innerText = "패스워드가 일치합니다.";
		availablePassword = true;
	} else {
		passwordText1.innerText = "패스워드가 일치하지 않습니다.";
	}
	
	enableSubmitButton();

}

passwordInput1.addEventListener("keyup", matchPassword);
passwordInput2.addEventListener("keyup", matchPassword);
/* 패스워드 일치하는 지 확인 끝 */
</script>
</body>
</html>









