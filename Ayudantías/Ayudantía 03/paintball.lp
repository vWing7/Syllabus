tiempo(0..bound).

action(shoot).
action(reload).

1 {exec(P, A, T) : action(A)} 1 :- player(P), tiempo(T+1), alive(P, T).

%Un jugador dispara, y este disparo llega a uno de los jugadores que tiene en la mira
1 {shoots(P1,P2,T): pointsAt(P1,P2), player(P2)} 1:- exec(P1, shoot, T), tiempo(T+1), player(P1).

%Un jugador recarga y se esconde durante ese turno
hidden(P,T) :- player(P), exec(P,reload,T), tiempo(T).

%Si alguien te dispara y no estás escondido, te están disparando
beingShot(P1, T) :- shoots(P2, P1, T), not hidden(P1,T).

%Si no te han disparado, sigues vivo
alive(P1, T+1):- alive(P1, T), not beingShot(P1, T), tiempo(T+1), player(P1).

%No funciona:
%alive(P1, T+1):- alive(P1, T), not shoots(P2, P1, T), tiempo(T+1), player(P1), player(P2).

%Si no estás vivo, estás muerto
dead(P,T) :- not alive(P,T), player(P), tiempo(T).

%Cada jugador puede estar escondido a lo más 2 turnos
:-player(P), #count{T: hidden(P,T)} > 2.



%Minimizar cantidad de jugadores vivos
#minimize{1, P: alive(P, bound)}.

%Minimizar cantidad de jugadores muertos
%#minimize{1, P: dead(P, bound)}.

#show dead/2.
#show shoots/3.
#show hidden/2.