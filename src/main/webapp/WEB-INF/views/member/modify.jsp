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

<my:navBar/>

<div class="container-md">
	<div class="row">
		<div class="col">

			<c:if test="${not empty message }">
				<div class="alert alert-success">
						${message }
				</div>
			</c:if>

			<h1>회원 정보 수정</h1>

			<form id="form1" action="" method="post">

				<div class="mb-3">
					<label for="" class="form-label">
						아이디
					</label>
					<input class="form-control" type="text" value="${member.id }" readonly>
				</div>

				<div class="mb-3">
					<label for="" class="form-label">
						별명
					</label>
					<div class="input-group">
						<input id="nickNameInput1" class="form-control" type="text" value="${member.nickName }" name="nickName" data-old-value="${member.nickName }">
						<button disabled id="nickNameButton1" type="button" class="btn btn-outline-secondary">중복확인</button>
					</div>
					<div id="nickNameText1" class="form-text"></div>
				</div>

				<input type="checkbox" name="newPassword" value="true" id="newPasswordCheckbox1"> 암호 변경

				<div class="mb-3">
					<label for="" class="form-label">
						새 암호
					</label>
					<input disabled id="passwordInput1" class="form-control" type="text" value="" name="password">
					<div id="passwordText1" class="form-text"></div>
				</div>

				<div class="mb-3">
					<label for="" class="form-label">
						새 암호 확인
					</label>
					<input disabled id="passwordInput2" class="form-control" type="text">
				</div>


				<div class="mb-3">
					<label for="" class="form-label">
						이메일
					</label>
					<div class="input-group">
						<input id="emailInput1" class="form-control" type="email" value="${member.email }" name="email" data-old-value="${member.email }">
						<button disabled id="emailButton1" type="button" class="btn btn-outline-secondary">중복확인</button>
					</div>
					<div id="emailText1" class="form-text"></div>
				</div>
				<div class="mb-3">
					<label for="" class="form-label">
						가입일시
					</label>
					<input class="form-control" type="text" value="${member.inserted }" readonly>
				</div>

				<input type="hidden" name="oldPassword">
			</form>

			<c:url value="/member/remove" var="removeUrl" />
			<form id="form2" action="${removeUrl }" method="post">
				<input type="hidden" name="id" value="${member.id }">
				<input type="hidden" name="oldPassword">
			</form>
			<input disabled id="modifyModalButton1" class="btn btn-warning" type="submit" value="수정" data-bs-toggle="modal" data-bs-target="#modifyModal">
			<input class="btn btn-danger" type="submit" value="탈퇴" data-bs-toggle="modal" data-bs-target="#removeModal">
		</div>
	</div>
</div>

<%-- 수정 시 예전암호 입력 Modal --%>
<div class="modal fade" id="modifyModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="exampleModalLabel">기존 암호 입력</h1>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<input id="oldPasswordInput1" type="text" class="form-control">
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
				<button id="modalConfirmButton" type="button" class="btn btn-primary">수정</button>
			</div>
		</div>
	</div>
</div>

<%-- 탈퇴 시 예전암호 입력 Modal --%>
<div class="modal fade" id="removeModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="exampleModalLabel">기존 암호 입력</h1>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<input id="oldPasswordInput2" type="text" class="form-control">
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
				<button id="modalConfirmButton2" type="button" class="btn btn-danger">탈퇴</button>
			</div>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script>
	const ctx = "${pageContext.request.contextPath}";

	let availablePassword = true;
	let availableEmail = true;
	let availableNickName = true;

	function enableModifyButton() {
		const button = document.querySelector("#modifyModalButton1");
		if (availablePassword && availableEmail && availableNickName) {
			// 수정버튼 활성화
			button.removeAttribute("disabled")
		} else {
			// 수정버튼 비활성화
			button.setAttribute("disabled", "");
		}
	}

	<%-- 새 패스워드 입력 체크박스 --%>
	document.querySelector("#newPasswordCheckbox1").addEventListener("change", function() {
		const pwInput1 = document.querySelector("#passwordInput1");
		const pwInput2 = document.querySelector("#passwordInput2");
		if (this.checked) {
			pwInput1.removeAttribute("disabled");
			pwInput2.removeAttribute("disabled");
		} else {
			pwInput1.setAttribute("disabled", "");
			pwInput2.setAttribute("disabled", "");
		}
	});

	<%-- 이메일 중복확인 --%>
	const emailInput1 = document.querySelector("#emailInput1");
	const emailButton1 = document.querySelector("#emailButton1");
	const emailText1 = document.querySelector("#emailText1");

	// 이메일 중복확인 버튼 클릭하면
	emailButton1.addEventListener("click", function() {
		availableEmail = false;

		const email = emailInput1.value;

		fetch(`\${ctx}/member/existEmail`, {
			method : "post",
			headers : {
				"Content-Type" : "application/json"
			},
			body : JSON.stringify({email})
		})
				.then(res => res.json())
				.then(data => {
					emailText1.innerText = data.message;

					if (data.status == "not exist") {
						availableEmail = true;
					}
					enableModifyButton();
				});
	});

	// 이메일 input의 값이 변경되었을 때
	emailInput1.addEventListener("keyup", function() {
		availableEmail = false;

		const oldValue = emailInput1.dataset.oldValue;
		const newValue = emailInput1.value;
		if (oldValue == newValue) {
			// 기존 이메일과 같으면 아무일도 일어나지 않음
			emailText1.innerText = "";
			emailButton1.setAttribute("disabled", "disabled");
			availableEmail = true;
		} else {
			// 기존 이메일과 다르면 중복체크 요청
			emailText1.innerText = "이메일 중복확인을 해주세요.";
			emailButton1.removeAttribute("disabled");
		}

		enableModifyButton();
	});

	<%-- 별명 중복확인 관련 코드 --%>
	let nickNameInput1 = document.querySelector("#nickNameInput1");
	let nickNameText1 = document.querySelector("#nickNameText1");
	let nickNameButton1 = document.querySelector("#nickNameButton1");

	//별명 중복확인 버튼 클릭하면
	nickNameButton1.addEventListener("click", function() {
		availableNickName = false;

		const nickName = nickNameInput1.value;

		fetch(`\${ctx}/member/existNickName/\${nickName}`)
				.then(res => res.json())
				.then(data => {
					nickNameText1.innerText = data.message;

					if (data.status == "not exist") {
						availableNickName = true;
					}
					enableModifyButton();
				});
	});

	//닉네임 input의 값이 변경되었을 때
	nickNameInput1.addEventListener("keyup", function() {
		availableNickName = false;

		const oldValue = nickNameInput1.dataset.oldValue;
		const newValue = nickNameInput1.value;
		if (oldValue == newValue) {
			// 기존 닉네임과 같으면 아무일도 일어나지 않음
			nickNameText1.innerText = "";
			nickNameButton1.setAttribute("disabled", "disabled");
			availableNickName = true;
		} else {
			// 기존 이메일과 다르면 중복체크 요청
			nickNameText1.innerText = "별명 중복확인을 해주세요.";
			nickNameButton1.removeAttribute("disabled");
		}

		enableModifyButton();
	});

	<%-- 암호 입력 일치하는지 확인 --%>
	const passwordInput1 = document.querySelector("#passwordInput1");
	const passwordInput2 = document.querySelector("#passwordInput2");
	const passwordText1 = document.querySelector("#passwordText1");

	passwordInput1.addEventListener("keyup", matchPassword);
	passwordInput2.addEventListener("keyup", matchPassword);

	function matchPassword() {
		availablePassword = false;
		if (passwordInput1.value == passwordInput2.value) {
			passwordText1.innerText = "패스워드가 일치 합니다.";
			availablePassword = true;
		} else {
			passwordText1.innerText = "패스워드가 일치하지 않습니다.";
		}
		enableModifyButton();
	}

	<%-- 탈퇴 모달 확인 버튼 눌렀을 때 --%>
	document.querySelector("#modalConfirmButton2").addEventListener("click", function() {
		const form = document.forms.form2;
		const modalInput = document.querySelector("#oldPasswordInput2");
		const formOldPasswordInput = document.querySelector(`#form2 input[name="oldPassword"]`)
		// 모달 안의 기존 암호 input 값을
		// form의 기존 암호 input에 옮기고
		formOldPasswordInput.value = modalInput.value;

		// form을 submit
		form.submit();
	});

	<%-- 수정 모달 확인 버튼 눌렀을 때 --%>
	document.querySelector("#modalConfirmButton").addEventListener("click", function() {
		const form = document.forms.form1;
		const modalInput = document.querySelector("#oldPasswordInput1");
		const formOldPasswordInput = document.querySelector(`#form1 input[name="oldPassword"]`)
		// 모달 암호 input 입력된 값을
		// form 안의 기존암호 input에 옮기고
		formOldPasswordInput.value = modalInput.value;

		// form을 submit
		form.submit();
	});
</script>
</body>
</html>










