import 'package:flutter/material.dart';
import '../models/criminal_case_model.dart';
import '../models/crime_card_model.dart';
import '../models/case_model.dart';

class CriminalCasesData {
  static List<CriminalCaseModel> getInitialCases() {
    return [
      // ========================================================
      // CASO 1: O NÓ CENTRAL - O HOMICÍDIO NA MANSÃO RAVENWOOD
      // (Nível: Complexo • 4 Categorias de Cartas • Missões no App)
      // ========================================================
      CriminalCaseModel(
        id: 'case_ravenwood',
        title: 'O Assassinato na Mansão Ravenwood',
        category: 'Homicídio Qualificado & Fraude Forense',
        difficulty: 'Difícil',
        victim: 'Lorde Vincent Ravenwood (58 anos, aristocrata e botânico amador)',
        crimeScene: 'Biblioteca trancada por dentro com taça quebrada.',
        timeOfCrime: 'Entre 22h40 e 23h15 de sábado (noite de tempestade).',
        synopsis: 'O corpo foi encontrado na poltrona da biblioteca com uma taça partida e uma garrafa com cianeto. Porém, o legista notou que a biblioteca foi uma cena montada para parecer suicídio! Alguém envenenou o Lorde em outro local e carregou o corpo.',
        rewardPoints: 300,
        mapX: 0,
        mapY: 0,
        isRoot: true,
        status: CaseStatus.unlocked,

        // Solução Real do Crime (4 Cartas Conectadas)
        solutionSuspectId: 'card_suspect_beatrice',
        solutionWeaponId: 'card_weapon_aconite',
        solutionLocationId: 'card_loc_greenhouse',
        solutionEvidenceId: 'card_ev_mud_soil',

        crimeResolutionStory:
            'CRIME DESVENDADO COM PRECISÃO FORENSE!\n\nLady Beatrice descobriu que o tio a deserdaria e arquitetou o crime. O Lorde NÃO foi envenenado na biblioteca: Beatrice preparou um chá com Extrato de Aconitina (planta mortal que ela mesma colheu na Estufa de Orquídeas às 22h45).\n\nApós o colapso da vítima na estufa, Beatrice chantageou o mordomo Arthur para carregar o corpo até a biblioteca, quebrar uma taça com cianeto falso e trancar a porta por baixo com um fio de seda.\n\nA prova irrefutável que destruiu o álibi foi o Pólen de Orquídea Rara e o Barro Vermelho exclusivo da estufa encontrado incrustado no vestido de Beatrice!',

        // MISSÕES COM PROVAS PERICIAIS EXPLÍCITAS PARA O JOGADOR LER E DEDUZIR
        inAppMissions: [
          InAppMission(
            id: 'm_ravenwood_1',
            title: 'Perícia Toxicológica do Sangue',
            type: MissionType.chemicalTest,
            forensicClueDocument:
                'LAUDO DO MÉDICO LEGISTA (DOC-01):\n"Examinamos a taça quebrada na biblioteca e encontramos Cianeto. No entanto, o exame toxicológico do sangue de Lorde Vincent deu NEGATIVO para cianeto! A verdadeira causa da morte foi paralisia cardíaca súbita por alcalóide vegetal.\n\nNo caderno botânico particular do Lorde, há um aviso grifado em vermelho: \'O extrato de Aconitina, retirado da flor Capuz-de-Monge cultivada na estufa, paralisa o miocárdio em minutos sem deixar o forte cheiro de amêndoas do cianeto\'."',
            description: 'Leia o relatório do legista acima para descobrir qual substância vegetal foi a real causadora do óbito.',
            challengeQuestion: 'Com base no laudo que descartou o cianeto e na anotação do diário botânico, qual veneno causou a morte?',
            options: [
              'Arsênico em pó de veneno de rato',
              'Extrato de Aconitina (Flor Capuz-de-Monge)',
              'Cianeto de potássio na garrafa de licor',
              'Monóxido de carbono inalado',
            ],
            correctOptionIndex: 1,
            explanation: 'Excelente dedução! O cianeto na biblioteca era uma armadilha forjada. A vítima faleceu pela ingestão de Aconitina.',
            unlockedCardTitle: 'Cartas de Armas & Substâncias Letais',
            unlocksCardIds: ['card_weapon_aconite', 'card_weapon_cyanide', 'card_weapon_dagger'],
            points: 80,
          ),
          InAppMission(
            id: 'm_ravenwood_2',
            title: 'Exame do Relógio de Bolso & Barro',
            type: MissionType.alibiCrossCheck,
            forensicClueDocument:
                'RELATÓRIO DA PERÍCIA FÍSICA (DOC-02):\n"O relógio de bolso de ouro de Lorde Vincent foi encontrado com o vidro estilhaçado e os ponteiros travados exatamente às 22h45 pelo impacto da queda.\n\nNas ranhuras da caixa do relógio e nas meias da vítima, a perícia coletou barro vermelho úmido.\n\nConstatação da Mansão: O piso da biblioteca é de madeira nobre encerada e seca. O ÚNICO ambiente de toda a propriedade que possui solo de barro vermelho úmido é o canteiro da Estufa de Orquídeas nos jardins de inverno."',
            description: 'Cruze a hora em que o relógio quebrou com o tipo de solo encontrado para determinar a cena primária do ataque.',
            challengeQuestion: 'Sabendo que o relógio parou na queda às 22h45 com terra vermelha, onde Lorde Vincent foi atacado antes de ser movido?',
            options: [
              'Na Sala de Jantar Principal',
              'Na Estufa de Orquídeas (único local com barro vermelho)',
              'No Quarto de Hóspedes do andar superior',
              'Na Adega Subterrânea de vinhos',
            ],
            correctOptionIndex: 1,
            explanation: 'Dedução perfeita! O ataque mortal ocorreu na estufa às 22h45. O corpo foi colocado na biblioteca mais tarde.',
            unlockedCardTitle: 'Cartas de Locais da Cena do Crime',
            unlocksCardIds: ['card_loc_greenhouse', 'card_loc_library', 'card_loc_wine_cellar'],
            points: 80,
          ),
          InAppMission(
            id: 'm_ravenwood_3',
            title: 'Confronto do Álibi sob o Microscópio',
            type: MissionType.cipherDecode,
            forensicClueDocument:
                'DEPOIMENTO DE LADY BEATRICE vs LAUDO MICROSCÓPICO (DOC-03):\n"Em seu depoimento oficial, Lady Beatrice declarou: \'Passei a noite inteira trancada no meu quarto lendo e jamais pisei na estufa ou nos jardins\'.\n\nNo entanto, o laboratório forense examinou com luz ultravioleta a bainha do vestido de baile de Beatrice e encontrou duas evidências microscópicas indiscutíveis: esporos de Pólen de Orquídea Imperial (espécie rara que só floresce na estufa climatizada) e manchas secas de Barro Vermelho."',
            description: 'Examine o laudo laboratorial do vestido de Beatrice para identificar a prova irrefutável que anula seu álibi.',
            challengeQuestion: 'Qual vestígio microscópico destrói a alegação de Beatrice de que não saiu do quarto?',
            options: [
              'Cinzas de charuto cubano no tapete',
              'Pólen de Orquídea Imperial & Barro Vermelho na barra do vestido',
              'Fios de lã de sobretudo masculino de inverno',
              'Resíduos de tinta nanquim de caneta',
            ],
            correctOptionIndex: 1,
            explanation: 'Brilhante! O pólen da orquídea rara e o barro comprovam que Beatrice esteve diretamente na estufa no momento do crime.',
            unlockedCardTitle: 'Cartas de Vestígios Forenses Decisivos',
            unlocksCardIds: ['card_ev_mud_soil', 'card_ev_torn_will', 'card_ev_silk_thread'],
            points: 90,
          ),
        ],

        // 12 CARTAS DIVIDIDAS EM 4 CATEGORIAS FORENSES
        cards: [
          // 1. ACUSADOS (4 cartas)
          const CrimeCard(
            id: 'card_suspect_beatrice',
            title: 'Lady Beatrice',
            subtitle: 'A Sobrinha & Herdeira',
            type: CardType.suspect,
            description: 'Endividada em apostas clandestinas. Sabia que seria deserdada na manhã seguinte.',
            secretClue: 'LAUDO DO PERITO: Pólen de orquídea e barro vermelho na bainha de seu vestido provam sua presença na cena do crime.',
            icon: Icons.face_3,
            isKeyClue: true,
          ),
          const CrimeCard(
            id: 'card_suspect_arthur',
            title: 'Arthur Pendelton',
            subtitle: 'O Mordomo da Mansão',
            type: CardType.suspect,
            description: 'Subserviente há 30 anos. Ajudou a carregar o corpo sob chantagem de Beatrice.',
            secretClue: 'LAUDO DO PERITO: Havia barro nas galochas, mas ele confessou apenas ter transportado o corpo já sem vida após ameaças.',
            icon: Icons.person_outline,
            isKeyClue: false,
          ),
          const CrimeCard(
            id: 'card_suspect_julian',
            title: 'Dr. Julian Vance',
            subtitle: 'O Médico da Família',
            type: CardType.suspect,
            description: 'Receitava tônicos cardíacos para o Lorde. Tinha acesso a laboratórios químicos.',
            secretClue: 'LAUDO DO PERITO: Registros do hospital comprovam cirurgia de emergência das 21h30 às 01h00. Álibi confirmado.',
            icon: Icons.medical_services_outlined,
            isKeyClue: false,
          ),
          const CrimeCard(
            id: 'card_suspect_advogado',
            title: 'Walter Sterling',
            subtitle: 'O Advogado da Família',
            type: CardType.suspect,
            description: 'Trouxe a minuta do novo testamento que deserdava Beatrice em favor do orfanato.',
            secretClue: 'LAUDO DO PERITO: Ele embarcou no trem das 21h15, conforme confirmado pelo bilheteiro da estação central.',
            icon: Icons.gavel,
            isKeyClue: false,
          ),

          // 2. ARMAS DO CRIME (3 cartas)
          const CrimeCard(
            id: 'card_weapon_aconite',
            title: 'Extrato de Aconitina',
            subtitle: 'Veneno Vegetal Letal',
            type: CardType.weapon,
            description: 'Extraído das raízes da planta Capuz-de-Monge. Paralisa o miocárdio em minutos.',
            secretClue: 'LAUDO DO PERITO: Concentração fulminante identificada no sangue da vítima. Aconitina não possui odor de amêndoas.',
            icon: Icons.eco,
            isKeyClue: true,
          ),
          const CrimeCard(
            id: 'card_weapon_cyanide',
            title: 'Cianeto na Garrafa',
            subtitle: 'Pista Falsa Plantada',
            type: CardType.weapon,
            description: 'Garrafa de licor com pó branco deixada estrategicamente sobre a escrivaninha.',
            secretClue: 'LAUDO DO PERITO: Pista forjada. O exame de sangue comprovou ausência total de cianeto no organismo do Lorde.',
            icon: Icons.science_outlined,
            isKeyClue: false,
          ),
          const CrimeCard(
            id: 'card_weapon_dagger',
            title: 'Adaga Cerimonial',
            subtitle: 'Lâmina Espanhola Antiga',
            type: CardType.weapon,
            description: 'Punhal antigo da coleção particular fixado na parede de carvalho.',
            secretClue: 'LAUDO DO PERITO: Luminol negativo para sangue. A lâmina contém apenas cera de vela e poeira antiga.',
            icon: Icons.colorize,
            isKeyClue: false,
          ),

          // 3. LOCAIS DA CENA (3 cartas)
          const CrimeCard(
            id: 'card_loc_greenhouse',
            title: 'A Estufa de Orquídeas',
            subtitle: 'Local Real da Execução',
            type: CardType.location,
            description: 'Jardim de inverno climatizado onde o Lorde cultivava espécies botânicas exóticas.',
            secretClue: 'LAUDO DO PERITO: O relógio do Lorde quebrou no impacto com o solo às 22h45 aqui. O ataque letal ocorreu na estufa!',
            icon: Icons.yard_outlined,
            isKeyClue: true,
          ),
          const CrimeCard(
            id: 'card_loc_library',
            title: 'A Biblioteca Trancada',
            subtitle: 'Cena Falsificada',
            type: CardType.location,
            description: 'Escritório onde o cadáver foi depositado na poltrona para simular suicídio.',
            secretClue: 'LAUDO DO PERITO: O piso estava seco e a posição do corpo indica que ele foi posicionado já falecido.',
            icon: Icons.local_library_outlined,
            isKeyClue: false,
          ),
          const CrimeCard(
            id: 'card_loc_wine_cellar',
            title: 'A Adega Subterrânea',
            subtitle: 'Depósito de Vinhos',
            type: CardType.location,
            description: 'Local escuro onde o mordomo alega ter ido buscar a garrafa de vinho da ceia.',
            secretClue: 'LAUDO DO PERITO: Piso de pedra calcária seco, sem sinais de luta ou derramamento de líquidos.',
            icon: Icons.wine_bar_outlined,
            isKeyClue: false,
          ),

          // 4. VESTÍGIOS FORENSES (3 cartas)
          const CrimeCard(
            id: 'card_ev_mud_soil',
            title: 'Pólen & Barro Vermelho',
            subtitle: 'Vestígio Físico Decisivo',
            type: CardType.evidence,
            description: 'Micropartículas de terra avermelhada e esporos botânicos encontrados na estufa.',
            secretClue: 'LAUDO DO PERITO: Resíduos microscópicos ligando o vestido de gala de Beatrice diretamente ao Lorde na estufa.',
            icon: Icons.fingerprint,
            isKeyClue: true,
          ),
          const CrimeCard(
            id: 'card_ev_torn_will',
            title: 'Testamento Rasgado',
            subtitle: 'Motivação Financeira',
            type: CardType.evidence,
            description: 'Folha oficial do cartório com a assinatura do Lorde retirada da pasta.',
            secretClue: 'LAUDO DO PERITO: O documento doava 100% dos bens ao orfanato municipal caso o Lorde falecesse.',
            icon: Icons.description_outlined,
            isKeyClue: false,
          ),
          const CrimeCard(
            id: 'card_ev_silk_thread',
            title: 'Fio de Seda na Tranca',
            subtitle: 'Mecanismo do Quarto Fechado',
            type: CardType.evidence,
            description: 'Fio fino de seda preta preso na maçaneta externa e passado sob a porta.',
            secretClue: 'LAUDO DO PERITO: Usado para girar a chave na fechadura do lado de dentro puxando pelo vão inferior.',
            icon: Icons.linear_scale,
            isKeyClue: false,
          ),
        ],
      ),

      // CASO 2: O ENVENENAMENTO NO JAZZ CLUB
      CriminalCaseModel(
        id: 'case_jazz_club',
        title: 'O Envenenamento no Velvet Club',
        category: 'Homicídio Premeditado',
        difficulty: 'Muito Difícil',
        victim: 'Stella Fontaine (26 anos, cantora e estrela da noite)',
        crimeScene: 'Camarim VIP trancado durante o solo de saxofone.',
        timeOfCrime: '00h15 da madrugada de domingo.',
        synopsis: 'Stella desmaiou nos braços do maestro logo após o refrão final. O camarim estava trancado, mas as janelas davam para o beco dos fundos.',
        rewardPoints: 350,
        mapX: 0,
        mapY: -110,
        parentCaseIds: ['case_ravenwood'],
        status: CaseStatus.locked,
        solutionSuspectId: 'card_jazz_rossi',
        solutionWeaponId: 'card_jazz_perfume',
        solutionLocationId: 'card_jazz_backstage',
        solutionEvidenceId: 'card_jazz_receipt',
        crimeResolutionStory:
            'O CULPADO É SALVATORE ROSSI! O dono do clube devia uma fortuna para agiotas. Ele contratou um seguro milionário no nome de Stella e adulterou o frasco de perfume no camarim antes do espetáculo.',
        inAppMissions: [],
        cards: [],
      ),

      // CASO 3: O ROUBO DO DIAMANTE IMPERIAL
      CriminalCaseModel(
        id: 'case_diamond_heist',
        title: 'O Roubo do Diamante Imperial',
        category: 'Conspiração & Falsa Evidência',
        difficulty: 'Muito Difícil',
        victim: 'Museu Metropolitano de Joias',
        crimeScene: 'Cofre acorrentado com sensores térmicos.',
        timeOfCrime: '03h14 da manhã.',
        synopsis: 'A gema original de 120 quilates foi substituída por uma réplica de zircônio. Nenhum alarme tocou.',
        rewardPoints: 400,
        mapX: 110,
        mapY: -20,
        parentCaseIds: ['case_ravenwood'],
        status: CaseStatus.locked,
        solutionSuspectId: '',
        solutionWeaponId: '',
        solutionLocationId: '',
        solutionEvidenceId: '',
        crimeResolutionStory: '',
        inAppMissions: [],
        cards: [],
      ),

      // CASO 4: O EXPRESSO DAS NEVES
      CriminalCaseModel(
        id: 'case_snow_express',
        title: 'A Morte no Expresso das Neves',
        category: 'Espionagem & Homicídio',
        difficulty: 'Extremo',
        victim: 'Viktor Karkarov (diplomata espião)',
        crimeScene: 'Vagão leito 7 em movimento a 90 km/h.',
        timeOfCrime: '04h00 no túnel alpino.',
        synopsis: 'O homem foi achado morto com um jornal aberto no colo e uma agulha microscópica no colarinho.',
        rewardPoints: 450,
        mapX: 0,
        mapY: 110,
        parentCaseIds: ['case_ravenwood'],
        status: CaseStatus.locked,
        solutionSuspectId: '',
        solutionWeaponId: '',
        solutionLocationId: '',
        solutionEvidenceId: '',
        crimeResolutionStory: '',
        inAppMissions: [],
        cards: [],
      ),

      // CASO 5: O FAROL DO FIM DO MUNDO
      CriminalCaseModel(
        id: 'case_lighthouse',
        title: 'O Enigma do Farol Abandonado',
        category: 'Sabotagem Naval',
        difficulty: 'Extremo',
        victim: 'Capitão Thomas Reed (faroleiro veterano)',
        crimeScene: 'Cúpula da lâmpada gigante com fios seccionados.',
        timeOfCrime: 'Meia-noite de maré alta.',
        synopsis: 'O farol apagou no exato momento da passagem do cargueiro Neptune. O capitão desapareceu.',
        rewardPoints: 500,
        mapX: -110,
        mapY: -20,
        parentCaseIds: ['case_ravenwood'],
        status: CaseStatus.locked,
        solutionSuspectId: '',
        solutionWeaponId: '',
        solutionLocationId: '',
        solutionEvidenceId: '',
        crimeResolutionStory: '',
        inAppMissions: [],
        cards: [],
      ),
    ];
  }
}
