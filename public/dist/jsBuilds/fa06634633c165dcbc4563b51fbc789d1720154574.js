"use strict";$(function(){$('.notifications-nav-mobile').mCustomScrollbar({theme:"minimal-dark",axis:'x',scrollInertia:200,});});var notifications={data:{},updateUserNotificationsList:function(activeFilter){$.ajax({type:'GET',url:activeFilter!==null?app.baseUrl+'/my/notifications'+activeFilter+'?page=1&list=1':app.baseUrl+'/my/notifications?page=1&list=1',success:function(result){$('.notifications-wrapper').html(result);}});},};