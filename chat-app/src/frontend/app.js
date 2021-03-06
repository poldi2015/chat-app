import backendURL from './backend_url.js'

var me = {};
me.avatar = "./karate-left.gif";

var you = {};
you.avatar = "./karate-right.gif";


function formatAMPM(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
}

function insertChat(who, text) {
    var control = "";
    var date = formatAMPM(new Date());

    if (who == "me") {
        control = '<li style="width:100%">' +
            '<div class="msj macro">' +
            '<div class="avatar"><img class="img-circle" width="120" height="120" src="' + me.avatar + '" /></div>' +
            '<div class="text text-l">' +
            '<p>' + text + '</p>' +
            '<p><small>' + date + '</small></p>' +
            '</div>' +
            '</div>' +
            '</li>';
    } else {
        control = '<li style="width:100%;">' +
            '<div class="msj-rta macro">' +
            '<div class="text text-r">' +
            '<p>' + text + '</p>' +
            '<p><small>' + date + '</small></p>' +
            '</div>' +
            '<div class="avatar" style="padding:0px 0px 0px 10px !important"><img class="img-circle" width="120" height="120" src="' + you.avatar + '" /></div>' +
            '</li>';
    }
    $("ul").append(control).scrollTop($("ul").prop('scrollHeight'));
}

function resetChat() {
    $("ul").empty();
}

function sendMessage(client,text) {
    if (text !== "") {
        let message = {
            action: "sendmessage",
            data: text
        };
        client.send(JSON.stringify(message));
    }
}

$(document).ready(function () {

    let client = new WebSocket(backendURL, 'None');

    client.onmessage = function (e) {
        insertChat("you", e.data);
    }

    $("#mytext").keydown(function (e) {
        if (e.which == 13) {
            let text = $(this).val();
            sendMessage(client,text);
            $(this).val('');
        }
    });

    $('#sendbutton').click(function () {
        $("#mytext").trigger({ type: 'keydown', which: 13, keyCode: 13 });
    })

    resetChat();

    insertChat(me, "Welcome!")
})