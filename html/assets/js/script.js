let ResourceName = 'esx_paintball';
let weapons = [
    'advancedrifle.png',      'appistol.png',
    'assaultrifle.png', 
    'assaultshotgun.png',     'assaultsmg.png',
    'autoshotgun.png',        'bullpuprifle.png',
    'carbinerifle.png',
    'combatmg.png', 
    'combatpdw.png',          'combatpistol.png',
    'compactrifle.png',       'dbshotgun.png',
    'doubleaction.png',       'gusenberg.png',
    'heavypistol.png',
    'heavysniper.png',
    'machinepistol.png',      'marksmanpistol.png',
    'marksmanrifle.png',
    'mg.png',                 'microsmg.png',
    'minismg.png',
    'musket.png',             'pistol.png',
    'pistol50.png',
    'pumpshotgun.png',
    'revolver.png',
    'smg.png',
    'snspistol.png',
    'specialcarbine.png',
    'vintagepistol.png'
];

let maps = {
	"bank":"bank.png",
	"bimeh":"bimeh.png",
	"cargo":"cargo.png",
	"skyscraper":"skyscraper.png",
	"shop1":"shop1.png",
	"shop2":"shop2.png",
	"javaheri":"javaheri.png",
	"1v1":"1v1.png",
	"keshti":"keshti.png",
	"jahanam":"jahanam.png",
	"BankSheriff":"BankSheriff.png",
	"vila":"vila.png",
	"club":"club.png",
	"vault":"vault.png",
}
var lobbyID, TeamID, mapping, SWeapon, lobbyname, friendlyFire, roundNum, TotalPlayers;
var page = 0;

// Create Lobby Functions
function onCreateLobby(){
    $('.question').css('display', 'none');
    $('div[name="createlobby"]').css('display', 'block');
};
function onChangeMap(){
    var newSelect = $('#map').val();
    $('.map-img').attr('src', './assets/imgs/'+maps[newSelect])
};
function LeftWeaponButton() {
    var nowSelect = $('.weapon-select img').attr('src').split('/');
    if(weapons.indexOf(nowSelect[3]) > 0){
        $('.weapon-select img').attr('src', './assets/weapons/'+weapons[weapons.indexOf(nowSelect[3])-1]);
        $('.weapon-name').attr('id', weapons[weapons.indexOf(nowSelect[3])-1].split('.')[0]);
        $('.weapon-name').html(weapons[weapons.indexOf(nowSelect[3])-1].split('.')[0].replace('_', ' '));
    }else{
        $('.weapon-select img').attr('src', './assets/weapons/'+weapons[weapons.length-1]);
        $('.weapon-name').attr('id', weapons[weapons.length-1].split('.')[0]);
        $('.weapon-name').html(weapons[weapons.length-1].split('.')[0].replace('_', ' '));
    };
};
function RightWeaponButton() {
    var nowSelect = $('.weapon-select img').attr('src').split('/');
    if(weapons.indexOf(nowSelect[3]) == weapons.length-1){
        $('.weapon-select img').attr('src', './assets/weapons/'+weapons[0]);
        $('.weapon-name').attr('id', weapons[0].split('.')[0]);
        $('.weapon-name').html(weapons[0].split('.')[0].replace('_', ' '));
    }else{
        $('.weapon-select img').attr('src', './assets/weapons/'+weapons[weapons.indexOf(nowSelect[3])+1]);
        $('.weapon-name').attr('id', weapons[weapons.indexOf(nowSelect[3])+1].split('.')[0]);
        $('.weapon-name').html(weapons[weapons.indexOf(nowSelect[3])+1].split('.')[0].replace('_', ' '));
    };
};
function onSubmit(){
    lobbyname = $('#lname');
    lobbypass = $('#lbpass');
    roundNum = $('#round');
    rtime = 180;
    armor = $('#armor');
    headbox = $('#headbox');
    gunattachs = 1;
    if(lobbyname.length != 0 && lobbyname.val().length > lobbyname.attr('minlength')){
        var max = roundNum.attr('max');
        if(roundNum.val() > 0 && parseInt(roundNum.val()) <= parseInt(max)){
            fetch(`https://${ResourceName}/CreateLobby`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    mapName: mapping,
                    weaponModel: SWeapon,
                    lobbyName: lobbyname.val(),
                    roundNum: roundNum.val(),
                    armor: armor.val(),
                    rtime: 180,
                    headbox: headbox.val(),
                    gunattachs: 1,
                    Password: lobbypass.val()
                })
            }).then(resp => resp.json()).then(lobid => {
                lobbyID = lobid
            });
            page = 100;
            TeamID = 0;
            $('div[name="createlobby"]').css('display', 'none');
            $('#startButton').css('display', 'block');
            $('div[name="main"]').css('display', 'block');
        }else{
            roundNum.val(max);
            $('#round').css('border-color', 'red');
        };
    }else{
        $('#lname').css('border-color', 'red');
    };
};

function GetLobbies() {
    fetch(`https://${ResourceName}/LobbyList`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(data => {
        var jdata = JSON.parse(data);
        if(jdata.length != 0){
			$('.boxlobbeys').html('');
            for(var i=0;i<jdata.length;i++){
                if(jdata[i].pass == null || jdata[i].pass == ""){
                    $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-'+jdata[i].LobbyId+'" onclick="onSelectLobby(this.id)">'+jdata[i].name+' | '+jdata[i].map+' | '+jdata[i].weapon+'</h1>');
                }else{
                    $('.boxlobbeys').append('<h1 class="lobbeys" id="Lobby-'+jdata[i].LobbyId+'-locked" onclick="onSelectLobby(this.id)">'+jdata[i].name+' | '+jdata[i].map+' | Locked</h1>');
                };
            };
        }else{
            $('.boxlobbeys').append('<h1 class="lobbeys">لابی یافت نشد</h1>');
        };
    });
}
function onJoinLobby(){
    $('.question').css('display', 'none');
    $('.list').css('display', 'block');
	GetLobbies()
};
function onSelectLobby(id){
    var lid = id.split('-');
    lobbyID = lid[1];
    if(lid[2] == 'locked'){
        $('.lobby-password').css('visibility', 'visible');
        $('.lobbeys').css('display', 'none');
        page = 85;
    }else{
        page = 0;
        TeamID = 0;
        $('.list').css('display', 'none');
        $('#startButton').css('display', 'none');
        $('div[name="main"]').css('display', 'block');
        fetch(`https://${ResourceName}/JoinLobby`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                LobbyId: lobbyID
            })
        }).then(resp => resp.json()).then(data => {
            var jdata = JSON.parse(data);
            for(var i=0;i<3;i++){
                var team = jdata[i];
                for(var i2=0;i2<team.length;i2++){
                    if(i == 0){
                        $('.joiners').append(team[i2].value);
                    }else if(i == 1){
                        $('.teamone').append(team[i2].value);
                    }else{
                        $('.teamtwo').append(team[i2].value);
                    };
                };
            };
        });
    };
};
function onJoin(id){
    var tid = id.split('-')[1];
    fetch(`https://${ResourceName}/SwitchTeam`, 
	{
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            LastTeam: TeamID,
            JoinTeam: tid
        })
    }).then(resp => resp.json()).then(data => 
	{
        if(data)
		{
            if(TeamID != 0){
                $('#TM-'+TeamID).css('display', 'block');
            };
            $('#'+id).css('display', 'none');
            page = 100;
            TeamID = tid;
        };
    })
};

// In Lobby Functions
function onStart(){
    page = 0;
    fetch(`https://${ResourceName}/StartMatch`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID
        })
    }).then(resp => resp.json());
};
function onReady(){
    $('#ReadyButton').css('display', 'none');
    $('#UnReadyButton').css('display', 'block');
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: true
        })
    }).then(resp => resp.json());
};
function onUnready(){
    $('#UnReadyButton').css('display', 'none');
    $('#ReadyButton').css('display', 'block');
    fetch(`https://${ResourceName}/ToggleReadyPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID,
            ready: false
        })
    }).then(resp => resp.json());
};
function onLeave(){
    page = 0;
    $('.lobby').css('display', 'none');
    fetch(`https://${ResourceName}/QuitLobby`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            LobbyId: lobbyID,
            Team: TeamID
        })
    }).then(resp => resp.json());
    TeamID = 0;
    lobbyID = 0;
    location.reload();
};

// Other Functions
function onNext(){
    if(page == 0){
        $('#cancelButton').css('display', 'none');
        $('#backButton').css('display', 'inline');
        $('.selectmap').css('display', 'none');
        $('.weapon-select').css('display', 'block');
        mapping = $('#map').val();
        page = page+1;
    }else{
        $('#nextButton').css('display', 'none');
        $('#submitButton').css('display', 'inline');
        $('.weapon-select').css('display', 'none');
        $('.setting').css('display', 'block');
        SWeapon = $('.weapon-name').attr('id');
        page = page+1;
    };
};
function onBack(){
    if(page == 2){
        $('#nextButton').css('display', 'inline');
        $('#submitButton').css('display', 'none');
        $('.weapon-select').css('display', 'block');
        $('.setting').css('display', 'none');
        page = page-1;
    }else{
        $('#cancelButton').css('display', 'inline');
        $('#backButton').css('display', 'none');
        $('.selectmap').css('display', 'block');
        $('.weapon-select').css('display', 'none');
        page = page-1;
    };
};
function onCancel(){
    page = 0;
    $('.lobby').css('display', 'none');
    fetch(`https://${ResourceName}/QuitFromMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json());
    location.reload()
};
function onBackQuestion(){
    if(page != 85){
        $('.question').css('display', 'block');
        $('.list').css('display', 'none');
        $('.boxlobbeys').find('h1').remove();
    }else{
        page = 0
        $('.lobby-password').css('visibility', 'hidden');
        $('.lobbeys').css('display', 'block');
    };
};

// Keyup Event
document.onkeyup = function(data) {
    if(data.which == 27){ // ESC Press
        if(page == 0){
            fetch(`https://${ResourceName}/QuitFromMenu`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({})
            }).then(resp => resp.json());
            location.reload();
        };
    }else if(data.which == 13){
        if(page == 85){
            var pass = $('#lpass').val();
            if(pass != null || pass != ""){
                fetch(`https://${ResourceName}/GetLobbyPassword`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: JSON.stringify({
                        LobbyId: lobbyID,
						Password: pass
                    })
                }).then(resp => resp.json()).then(data => {
                    if(data == true){
                        page = 0;
                        TeamID = 0;
                        $('.list').css('display', 'none');
                        $('#startButton').css('display', 'none');
                        $('div[name="main"]').css('display', 'block');
                        fetch(`https://${ResourceName}/JoinLobby`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: JSON.stringify({
                                LobbyId: lobbyID
                            })
                        }).then(resp => resp.json()).then(data => {
                            var jdata = JSON.parse(data);
                            for(var i=0;i<3;i++){
                                var team = jdata[i];
                                for(var i2=0;i2<team.length;i2++){
                                    if(i == 0){
                                        $('.joiners').append(team[i2].value);
                                    }else if(i == 1){
                                        $('.teamone').append(team[i2].value);
                                    }else{
                                        $('.teamtwo').append(team[i2].value);
                                    };
                                };
                            };
                        });
                    }else{
                        $('#lpass').css('border-color', 'red');
                    };
                });
            };
        };
    };
};

var SecondCounter = -1
setInterval(() =>
{
	if(SecondCounter != -1)
	{
		var date = new Date(0);
		date.setSeconds(SecondCounter);
		var timeString = date.toISOString().substr(14, 8);
		$('.btn-grad4').html(timeString.replace(".00", ""));
		SecondCounter--;
	}
}, 1000)

function addKill(killer, weapon, killed, headshot) 
{
    let killerName = sanitizeString(killer.name);
    let killedName = sanitizeString(killed.name);

    let killfeedElement = `
        <div class="kill-wrapper">
            <div class="kill">
                <p class="${killer.team}">${killerName}</p>
                ${(weapon == "VEHICLE") ? `<i style="padding-left: 5px; padding-right: 5px;" class="fas fa-car-side"></i>` : `<img src="https://cdn.gtakoth.com/weapons/${weapon}.png">`}
                ${(headshot) ? '<i class="fas fa-crosshairs"></i> ' : ""}
                <p class="${killed.team}">${killedName}</p>
            </div>
        </div>
    `;

    let elem = $(killfeedElement);
    $('.killfeed').append(elem);
    elem.hide().show(500);

    setTimeout(() => { elem.hide(500); setTimeout(() => { elem.html(""); }, 500); }, 5000);
}

function sanitizeString(str)
{
    str = str.replace(/[^a-z0-9áéíóúñü \.,_-]/gim,"");
    return str.trim();
}

// NUI Sended Event
window.addEventListener("message", function(event)
{
	if(event.data.type == 'show')
	{
		if(event.data.show){
			$('.lobby').css('display', 'block');
		}else{
			$('.lobby').css('display', 'none');
			this.location.reload();
		};
	};
	if(event.data.action == 'JoinTeam')
	{
		if(event.data.team == 0){
			$('.joiners').append(event.data.value);
		}else if(event.data.team == 1){
			$('.teamone').append(event.data.value);
		}else{
			$('.teamtwo').append(event.data.value);
		};
	}
	else if(event.data.action == 'LeftTeam')
	{
		$('#'+event.data.player).remove();
	}
	else if(event.data.action == 'ToggleReadyPlayer')
	{
		$('#'+event.data.player).html(event.data.value);
	}
	else if(event.data.action == "RefreshLobbies")
	{
        $('.boxlobbeys').find('h1').remove();
		GetLobbies()
	}
	else if(event.data.action == "ShowGameHUD")
	{
		if(event.data.value) $('.gamehud').css('display', 'block');
		else $('.gamehud').css('display', 'none');
	}
	else if(event.data.action == "SpectatePlayer")
	{
		if(event.data.value)
		{
			$('.btn-grad').html(event.data.value);
			$('.btn-grad').css('display', 'block');
		}
		else $('.btn-grad').css('display', 'none');
	}
	else if(event.data.action == "UpdateTeams")
	{
		if(event.data.team1 && event.data.team2)
		{
			$('.btn-grad2').html(event.data.team1 + " Wins");
			$('.btn-grad3').html(event.data.team2 + " Wins");
			$('.btn-grad2').css('display', 'block');			
			$('.btn-grad3').css('display', 'block');						
		}
		else
		{
			$('.btn-grad2').css('display', 'none');			
			$('.btn-grad3').css('display', 'none');									
		}
	}
	else if(event.data.action == "UpdateTotalRounds")
	{
		if(event.data.value)
		{
			$('.btn-grad5').html("Round " + (parseInt(event.data.value) + 1) + " / " + event.data.maxRounds);
			$('.btn-grad5').css('display', 'block');
		}
		else $('.btn-grad5').css('display', 'none');	
	}
	else if(event.data.action == "ResetRoundTimer")
	{
		if(event.data.value) 
		{
			$('.btn-grad4').css('background-color', 'rgba(' + event.data.r + ', ' + event.data.g + ', ' + event.data.b + ', 0.8)');			
			$('.btn-grad4').css('display', 'block');	
			SecondCounter = event.data.value;
		}
		else 
		{
			$('.btn-grad4').css('display', 'none');	
			SecondCounter = -1
		}
	}
	else if(event.data.topKillers)
	{
		for(var i = 0; i < 5; i++)
		{
			// var teamName = "", teamColor = "";			
			if(event.data.topKillers[i].team == 0)
			{
				 $('#topcat' + (i + 1)).fadeOut(850);
			}
			else
			{
				$('#topcat' + (i + 1)).fadeIn(850);
				if(event.data.topKillers[i].team == 1) 
				{
					// teamName = " (Blue)";
					$('#top' + (i + 1) + 'btn').css('background-image', 'linear-gradient(to right,#00c6ff 0%,#0072ff 51%,#00c6ff 100%)');
					$('#top' + (i + 1) + 'a').css('background-image', 'linear-gradient(to right,#00c6ff 0%,#0072ff 51%,#00c6ff 100%)');
				}
				else if(event.data.topKillers[i].team == 2) 
				{
					// teamName = " (Orange)";
					$('#top' + (i + 1) + 'btn').css('background-image', 'linear-gradient(to right,#FD9800 0%,#ffbf00 51%,#FD9800 100%)');
					$('#top' + (i + 1) + 'a').css('background-image', 'linear-gradient(to right,#FD9800 0%,#ffbf00 51%,#FD9800 100%)');
				}
			}
			$('#hud #top' + (i + 1)).text(event.data.topKillers[i].name/* + teamName*/);
			$('#hud #top' + (i + 1) + 'a #top' + (i + 1) + 'b').text(event.data.topKillers[i].kills);
		}
	}
});