<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML>
<html>
<head>
<base href="<%=basePath%>">
<title>My WebSocket</title>
</head>

<body>
	Welcome
	<br />
	<input id="text" type="text" />
	<button onclick="send()">Send</button>
	<button onclick="closeWebSocket()">Close</button>
	<div id="message"></div>
</body>

<script type="text/javascript">
	var websocket = null;
	window.setInterval(send, 5000);
	Date.prototype.format = function(format) {
		var o = {
			"M+" : this.getMonth() + 1, //month 
			"d+" : this.getDate(), //day 
			"h+" : this.getHours(), //hour 
			"m+" : this.getMinutes(), //minute 
			"s+" : this.getSeconds(), //second 
			"q+" : Math.floor((this.getMonth() + 3) / 3), //quarter 
			"S" : this.getMilliseconds()
		//millisecond 
		}

		if (/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + "")
					.substr(4 - RegExp.$1.length));
		}

		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
						: ("00" + o[k]).substr(("" + o[k]).length));
			}
		}
		return format;
	}

	//判断当前浏览器是否支持WebSocket
	if ('WebSocket' in window) {
		websocket = new WebSocket("ws://localhost:8080/testmybatis/websocket");
	} else {
		alert('Not support websocket')
	}

	//连接发生错误的回调方法
	websocket.onerror = function() {
		setMessageInnerHTML("error");
	};

	//连接成功建立的回调方法
	websocket.onopen = function(event) {
		setMessageInnerHTML("open");
	}

	//接收到消息的回调方法
	websocket.onmessage = function() {
		setMessageInnerHTML(event.data);
	}

	//连接关闭的回调方法
	websocket.onclose = function() {
		setMessageInnerHTML("close");
	}

	//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
	window.onbeforeunload = function() {
		websocket.close();
	}

	//将消息显示在网页上
	function setMessageInnerHTML(innerHTML) {
		document.getElementById('message').innerHTML = innerHTML + '<br/>';
	}

	//关闭连接
	function closeWebSocket() {
		websocket.close();
	}

	//发送消息
	function send() {
		var message = document.getElementById('text').value;
		var now = new Date(); 
		message = now.format("yyyy-MM-dd hh:mm:ss"); 
		websocket.send(message);
	}
</script>
</html>