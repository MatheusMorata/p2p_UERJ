# Simulação Freechains

<p>Este repositório contém uma simulação do funcionamento do freechains durante 3 meses.</p>

Usuários:

- Pioneiro
- Ativo
- Troll
- Novato

<p>
Pioneiro - É o usuário quem cria o fórum, ele posta a cada 1 dia, ele dá like sempre que a mensagem for sobre o vasco e se tiver reputação maior que 1

Active - Ele é o segundo usuário quem mais posta no fórum, ele posta a cada 2 dias, ele sempre dá like em postagens sobre o vasco e se tiver reputação maior que 18.

Troll - Ele manda apenas mensagens sobre o flamengo, ele posta a cada 2 dias igual o membro ativo, ele só dá dislike. 

Newbie - Ele é o usuário menos ativo, então ele só posta a cada 6 dias. Ele dá like quando ele tem 20 de reputação

**OBS:** Mensagens sobre o flamengo são consideras virais, mensagens sobre o vasco são consideradas boas. Os membros são vascainos com exceção do troll.

O script de simulação conta com 90 iterações (para simular 3 meses, aproximadamente cada mês com 30 iterações). Em cada iteração é feito a atualização dos timestamps de todos os nós, para manter a data igual em todos dias.
</p>