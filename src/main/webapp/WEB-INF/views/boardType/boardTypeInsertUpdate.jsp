<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="springconfig" uri="/WEB-INF/tlds/springjpa.tld" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>게시판 종류 등록/수정</title>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
	<!-- 부트스트랩 -->
	<link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<style>
		.col-xs-offset-5, .col-xs-2, .col-cs-offset-5, .col-lg-offset-5, .col-lg-2, .col-lg-offset-5 {
  			border: 0px solid red;
		}
    </style>
	<script src="/js/jquery-1.11.2.min.js"></script>
	<script src="/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function(){
		// ajax 작업시 캐쉬를 사용하지 않도록 한다
		$.ajaxSetup({ 
			cache: false
		});
		$("#btnRegist").click(function(){
			// $("#regfrm").submit();
			processjob(true);
		});
		
		$("#btnUpdate").click(function(){
			// $("#regfrm").submit();
			processjob(false);
		});
		
		$("#btnReset").click(function(){
			$("#regfrm")[0].reset();
		});
		
		$("#btnDelete").click(function(){
			var idx = $("#idx").val();
			$.ajax({
	        	url : "/boardType/boardTypeDelete.do",
	        	type : "POST",
	        	// data : JSON.stringify({"idx" : idx}),
	        	data : {"idx" : idx},
	        	// contentType: "application/json",	// contentType으로 지정하면 Request Body로 전달되기 때문에 Spring에서 받을때 다르게 접근해야 한다
	        	dataType : "json",
	        	success:function(data, textStatus, jqXHR){
	        		alert("<spring:message code='deleteOK' />");
	        		location.href="/boardType/boardTypeList.do";
	        	},
	        	error:function(jqXHR, textStatus, errorThrown){
	        		
	        		var alertMsg = "";
	        		if(jqXHR.status == 400){
	        			var responseJSON = jqXHR.responseJSON;
	        			var resultMap = responseJSON.resultMap;
	        			if(responseJSON.job == "Validate"){
	        				$.each(resultMap, function(k, v){
	        					alertMsg += v + "\n";
		        			});
	        				var pattern = /\n$/;
	        				alertMsg = alertMsg.replace(pattern, "");		// 에러 문자열을 결합하면 마지막 행 끝에 개행문자(\n)가 붙기 때문에 이를 제거하기 위해 정규표현식을 이용해서 마지막에 붙은 개행문자를 제거한다
	        				console.log(alertMsg);
		        			alert(alertMsg);
	        			}else if(responseJSON.job == "Ajax"){
	        				var alertMsg = resultMap.message;
	        				alert(alertMsg);
	        			}else{
	        				alert("<spring:message code='errorFail' />");
	        			}
	        		}else{
	        			alert("<spring:message code='errorFail' />");
	        		}
	        	}
	        });
		});
		
		$("#btnList").click(function(){
			location.href="/boardType/boardTypeList.do";
		});
		
		$("#regfrm").submit(function(event){
			event.preventDefault();
		});
	});
	
	function processjob(blInsert){
		
		var boardTypeName = $("#boardTypeName").val();
		var url = $("#url").val();
		
		var sendData = null;
		if(blInsert){
			sendData = JSON.stringify({"boardTypeName" : boardTypeName, "url" : url});
		}else{
			var idx = $("#idx").val();
			sendData = JSON.stringify({"idx" : idx, "boardTypeName" : boardTypeName, "url" : url});
		}
		
		$.ajax({
        	url : "/boardType/boardTypeInsertUpdate.do",
        	type : "POST",
        	// data : JSON.stringify({"idx" : idx, "boardTypeName" : boardTypeName, "url" : url}),
        	data : sendData,
        	// data : formSerialize,
        	contentType: "application/json",	// contentType으로 지정하면 Request Body로 전달되기 때문에 Spring에서 받을때 다르게 접근해야 한다
        	// processData: false,
        	dataType : "json",
        	beforeSend : function(xhr){
        		var validationResult = true;
        		if($.trim($("#boardTypeName").val()) == ""){
					alert("<spring:message code='NotBlank.boardTypeVO.boardTypeName' />");
					$("#boardTypeName").focus();
					validationResult = false;
        		}else if(($("#boardTypeName").val().length < 3) || ($("#boardTypeName").val().length > 10)){
					var alertMsg = "<spring:message code='Size.boardTypeVO.boardTypeName' />";
					alertMsg = alertMsg.replace("\{2\}", "3");
					alertMsg = alertMsg.replace("\{1\}", "10");
					alert(alertMsg);
					$("#boardTypeName").focus();
					validationResult = false;
				}else if($.trim($("#url").val()) == ""){
					alert("<spring:message code='NotBlank.boardTypeVO.url' />");
					$("#url").focus();
					validationResult = false;
				}else if(($("#url").val().length < 10) || ($("#url").val().length > 100)){
					var alertMsg = "<spring:message code='Size.boardTypeVO.url' />";
					alertMsg = alertMsg.replace("\{2\}", "10");
					alertMsg = alertMsg.replace("\{1\}", "100");
					alert(alertMsg);
					$("#url").focus();
					validationResult = false;
				}
        		return validationResult;
				
        	},
        	success:function(data, textStatus, jqXHR){
        		if(blInsert){
        			alert("<spring:message code='registOK' />");
        			location.href="/boardType/boardTypeList.do";
        		}else{
        			alert("<spring:message code='updateOK' />");
        		}		
        	},
        	error:function(jqXHR, textStatus, errorThrown){
        		var alertMsg = "";
        		if(jqXHR.status == 400){
        			var responseJSON = jqXHR.responseJSON;
        			var resultMap = responseJSON.resultMap;
        			if(responseJSON.job == "Validate"){
        				$.each(resultMap, function(k, v){
        					alertMsg += v + "\n";
	        			});
        				var pattern = /\n$/;
        				alertMsg = alertMsg.replace(pattern, "");		// 에러 문자열을 결합하면 마지막 행 끝에 개행문자(\n)가 붙기 때문에 이를 제거하기 위해 정규표현식을 이용해서 마지막에 붙은 개행문자를 제거한다
        				console.log(alertMsg);
	        			alert(alertMsg);
        			}else if(responseJSON.job == "Ajax"){
        				var alertMsg = resultMap.message;
        				alert(alertMsg);
        			}else{
        				alert("<spring:message code='errorFail' />");
        			}
        		}else{
        			alert("<spring:message code='errorFail' />");
        		}
        	}
        	
        });
	}
	</script>
</head>
<body>
	<div class="container">
		<div class="page-header">
			<c:choose>
				<c:when test="${result.idx eq null}">
					<h1>게시판 종류 등록</h1>
				</c:when>
				<c:otherwise>
					<h1>게시판 종류 수정</h1>
				</c:otherwise>
			</c:choose>
		</div>
		<form id="regfrm" method="post" class="form-horizontal" role="form">
		<div class="form-group">
			<label for="name" class="col-xs-2 col-lg-2 control-label">게시판 이름</label>
			<div class="col-xs-10 col-lg-10">
				<input id="boardTypeName" name="boardTypeName" class="form-control" placeholder="이름" value="<c:out value='${result.boardTypeName}' />" />
			</div>
		</div>
		<div class="form-group">
			<label for="url" class="col-xs-2 col-lg-2 control-label">URL</label>
			<div class="col-xs-10 col-lg-10">
				<input id="url" name="url" class="form-control" placeholder="URL" value="<c:out value='${result.url}' />" />
			</div>
		</div>
		<div class="form-group text-center">
			<div class="col-xs-offset-4 col-xs-4 col-cs-offset-4 col-lg-offset-4 col-lg-4 col-lg-offset-4">
				<c:choose>
					<c:when test="${result.idx eq null}">
						<button id="btnRegist" type="button" class="btn btn-default">등록</button>
					</c:when>
					<c:otherwise>
						<button id="btnUpdate" type="button" class="btn btn-default">수정</button>
						<button id="btnDelete" type="button" class="btn btn-default">삭제</button>
					</c:otherwise>
				</c:choose>
				<button id="btnReset" type="button" class="btn btn-default">재작성</button>
				<button id="btnList" type="button" class="btn btn-default">목록</button>
			</div>
		</div>
		<input type="hidden" id="idx" name="idx" value="<c:out value='${result.idx}' />" />
		</form>
	</div>
</body>
</html>