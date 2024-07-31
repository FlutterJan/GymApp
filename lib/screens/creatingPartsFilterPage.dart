import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucze_sie_swiry/screens/creatingEveryExercisePage.dart';

class Exercise {
  String id;
  String title;
  String titlePL;
  String bodyPart;
  String czesciCiala;
  bool tier;
  String gifCode;
  Widget namePage;
  int series;
  int reps;

  Exercise(
    this.id,
    this.title,
    this.titlePL,
    this.bodyPart,
    this.czesciCiala,
    this.tier,
    this.gifCode,
    this.namePage,
    this.series,
    this.reps,
  );
}

List<Exercise> _Exercises = [
  Exercise(
      '1',
      'Bench Press',
      "Wyciskanie na\nławce poziomej",
      'Chest, Triceps',
      "Klatka piersiowa, Triceps",
      true,
      "images/benchPress.jpg",
      CreatingExercisePage(
          1,
          "images/Chest.png",
          "Bench press is a popular strength training exercise that targets the chest, shoulders, and triceps. It involves lying flat on a bench with a barbell or dumbbells and pushing the weight away from the chest. Bench press is often considered a foundational exercise for building upper body strength and is a common component of many workout routines. There are different variations of the bench press, including the incline bench press and decline bench press, which target slightly different muscle groups. Proper form is important when performing the bench press to avoid injury and maximize the benefits of the exercise.\n\nTo avoid injuries during bench press, there are several important steps you can take:\n1.Warm up properly: Before you begin any heavy lifting, it's important to warm up your muscles and joints. Spend 5-10 minutes doing light cardio, stretching, and practicing the bench press movement with light weights.\n2.Start with a weight you can handle: It's important to start with a weight that you can lift comfortably for several repetitions. Gradually increase the weight as your strength improves.\n3.Maintain proper form: Keep your feet flat on the ground, your back flat against the bench, and your elbows tucked in. Don't arch your back or flare your elbows out. Use a spotter if you're lifting heavy weights.\n4.Breathe properly: Take a deep breath before lowering the weight, hold your breath as you lift, and exhale as you push the weight up.\n5.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during bench press and ensure that you're getting the most out of your workout.",
          '''Wyciskanie na ławce jest popularnym ćwiczeniem siłowym, które skupia się na klatce piersiowej, barkach i tricepsach. Polega na leżeniu płasko na ławce z sztangą lub hantlami i odepchnięciu ciężaru od klatki piersiowej. Wyciskanie na ławce jest często uważane za podstawowe ćwiczenie do budowania siły górnej części ciała i stanowi częsty składnik wielu programów treningowych. Istnieją różne warianty wyciskania na ławce, takie jak wyciskanie skośne i wyciskanie poziome, które skupiają się na nieco różnych grupach mięśni. Prawidłowa forma jest ważna podczas wykonywania wyciskania na ławce, aby uniknąć kontuzji i maksymalnie wykorzystać korzyści z tego ćwiczenia.

Aby uniknąć kontuzji podczas wyciskania na ławce, istnieje kilka ważnych kroków, które można podjąć:
1. Rozgrzewka: Przed rozpoczęciem ciężkiego podnoszenia, ważne jest, aby odpowiednio rozgrzać mięśnie i stawy. Poświęć 5-10 minut na lekkie ćwiczenia kardio, rozciąganie i praktykowanie ruchu wyciskania na ławce z lekkimi ciężarami.
2. Rozpocznij od ciężaru, który sobie poradzisz: Ważne jest, aby rozpocząć od ciężaru, który jesteś w stanie komfortowo podnieść przez kilka powtórzeń. Stopniowo zwiększaj ciężar w miarę poprawy siły.
3. Zachowaj prawidłową formę: Trzymaj stopy płasko na ziemi, plecy przyklejone do ławki i łokcie przy ciele. Nie wyginaj pleców ani nie rozstawiaj łokci na zewnątrz. Używaj obserwatora, jeśli podnosisz duże ciężary.
4. Prawidłowe oddychanie: Weź głęboki oddech przed opuszczeniem ciężaru, zatrzymaj oddech podczas podnoszenia i wydychaj, gdy unosisz ciężar.
5. Słuchaj swojego ciała: Jeśli odczuwasz ból lub dyskomfort, natychmiast przestań podnosić. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Śledząc te kroki, możesz pomóc uniknąć kontuzji podczas wyciskania na ławce i upewnić się, że maksymalnie wykorzystujesz swój trening.'''),
      3,
      8),
  Exercise(
      '2',
      'Dead Lift',
      "Martwy ciąg",
      'Glutes, Lats, Hamstrings, Quadriceps',
      "Pośladki, Plecy, Czworogłowy, Dwugłowy",
      true,
      "images/DeadLift.jpg",
      CreatingExercisePage(
          2,
          "images/DeadLiftMuscles.png",
          "Deadlift is a compound exercise that primarily targets the muscles in your lower body, including your hamstrings, glutes, and lower back. It involves lifting a barbell or weight off the ground, standing up straight, and then lowering the weight back down to the ground.\n\n1.Warm up properly: Before starting with heavy weights, spend 5-10 minutes doing light cardio, stretching, and practicing the deadlift movement with light weights.\n2.Maintain proper form: Keep your feet flat on the ground, your back straight, and your shoulders pulled back. Use your legs and hips to lift the weight, not your back.\n3.Use a mixed grip: Use one hand with an overhand grip and the other with an underhand grip to help you maintain control of the barbell and reduce the risk of it slipping from your hands.\n4.Use a lifting belt: A lifting belt can provide additional support for your lower back during heavy lifts.\n5.Gradually increase the weight: Start with a weight that you can handle comfortably for several repetitions, and gradually increase the weight as your strength improves.\n6.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during deadlift and ensure that you're getting the most out of your workout.",
          '''Martwy ciąg to ćwiczenie wielostawowe, które głównie angażuje mięśnie dolnej partii ciała, w tym łydki, pośladki i dolną część pleców. Polega na podnoszeniu sztangi lub obciążenia z podłogi, wstaniu prosto i opuszczeniu ciężaru z powrotem na podłogę.

1. Rozgrzewka: Zanim przystąpisz do ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio, rozciąganie i praktykowanie ruchu martwego ciągu z lekkimi obciążeniami.

2. Zachowuj prawidłową technikę: Trzymaj stopy płasko na podłodze, plecy proste i ramiona cofnięte. Używaj nóg i bioder do podnoszenia ciężaru, unikaj przeciążeń pleców.

3. Używaj chwytu mieszanej: Chwyt mieszany, gdzie jedna ręka trzyma sztangę nad dłonią, pomaga utrzymać kontrolę nad obciążeniem i zmniejsza ryzyko jego wypadnięcia z rąk.

4. Używaj pasa do podnoszenia: Pas do podnoszenia może dodatkowo wesprzeć dolną część pleców podczas ciężkich podciągnięć.

5. Stopniowo zwiększaj obciążenie: Zacznij od ciężaru, który jest dla ciebie komfortowy do wielu powtórzeń, a następnie stopniowo zwiększaj obciążenie w miarę wzrostu siły.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przestań podnosić. Nie forsuj się, ponieważ to może prowadzić do poważnych kontuzji.

Dzięki przestrzeganiu tych zasad, możesz uniknąć kontuzji podczas martwego ciągu i zapewnić, że twój trening przyniesie maksymalne korzyści.'''),
      3,
      8),
  Exercise(
      '3',
      'Pull Up',
      "Podciąganie",
      'Lats , Traps , Biceps ',
      'Plecy , Kaptury , Biceps ',
      true,
      "images/PullUp.jpg",
      CreatingExercisePage(
          3,
          "images/PullUp.png",
          "Pull-ups are a great exercise for working multiple muscle groups in the upper body, including the back, arms, and shoulders.\nTo avoid injuries while doing pull-ups, it's important to maintain proper form and technique throughout the exercise.Start by gripping the bar with an overhand grip and keeping your hands shoulder-width apart.Keep your shoulders down and engage your core muscles to maintain stability.When pulling yourself up, focus on using your back muscles rather than relying solely on your arms.Keep your elbows close to your body and aim to bring your chest towards the bar.Avoid using swinging or momentum to complete the exercise, as this can put unnecessary strain on your joints and muscles.It's also important to warm up properly before starting your pull-up routine and to gradually increase the intensity and difficulty of the exercise over time.",
          '''"Podciąganie to doskonałe ćwiczenie do pracy nad wieloma grupami mięśni górnej części ciała, w tym plecami, ramionami i barkami.
Aby uniknąć kontuzji podczas wykonywania podciągania, ważne jest zachowanie prawidłowej formy i techniki przez całe ćwiczenie. Zacznij od chwytu na drążku z nachwytem i trzymaj dłonie na szerokość ramion. Zachowaj opuszczone ramiona i zaangażuj mięśnie brzucha, aby utrzymać stabilność. Podciągając się, skup się na wykorzystaniu mięśni pleców, a nie polegaj wyłącznie na mięśniach ramion. Trzymaj łokcie blisko ciała i staraj się przyciągnąć klatkę piersiową w kierunku drążka. Unikaj machania lub impetu podczas wykonywania ćwiczenia, ponieważ może to niepotrzebnie obciążać stawy i mięśnie. Ważne jest także odpowiednie rozgrzanie przed rozpoczęciem rutyny podciągania oraz stopniowe zwiększanie intensywności i trudności ćwiczenia w miarę upływu czasu."'''),
      2,
      4),
  Exercise(
      '4',
      'Biceps Curl',
      "Uginanie bicepsów",
      "Biceps",
      "Biceps",
      true,
      "images/BicepsCurl.jpg",
      CreatingExercisePage(
          4,
          "images/BBicepsCurl.png",
          "Biceps curl is a strength training exercise that targets the biceps muscle in the upper arm. It involves lifting a weight, usually a dumbbell or barbell, from a position with your arms extended to a position where your elbows are bent and the weight is close to your chest.\n\nTo avoid injuries during biceps curl, there are several important steps you can take:\n1.Warm up properly: Before starting with heavy weights, spend 5-10 minutes doing light cardio, stretching, and practicing the biceps curl movement with light weights.\n2.Use proper form: Keep your back straight, your shoulders pulled back, and your elbows close to your sides. Use a controlled, smooth motion to lift the weight.\n3.Avoid swinging: Don't use momentum to swing the weight up. This can put unnecessary strain on your back and shoulders.\n4.Gradually increase the weight: Start with a weight that you can handle comfortably for several repetitions, and gradually increase the weight as your strength improves.\n5.Don't lift too heavy: Don't lift a weight that is too heavy for you to control. This can lead to poor form and increased risk of injury.\n6.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during biceps curl and ensure that you're getting the most out of your workout.",
          '''"Uginanie bicepsu to ćwiczenie siłowe, które skupia się na mięśniu bicepsu w górnej części ramienia. Polega na podnoszeniu ciężaru, zazwyczaj hantla lub sztangi, z pozycji, w której ramiona są wyprostowane, do pozycji, w której łokcie są zgięte, a ciężar jest blisko klatki piersiowej.

Aby uniknąć kontuzji podczas wykonywania podbicia bicepsu, istnieje kilka ważnych kroków, które można podjąć:
1. Rozgrzewka: Przed rozpoczęciem ćwiczeń z ciężkimi obciążeniami, poświęć 5-10 minut na lekkie ćwiczenia kardio, rozciąganie i praktykowanie ruchu podbicia bicepsu z lekkimi ciężarami.
2. Zachowaj prawidłową formę: Trzymaj plecy prosto, ramiona opuszczone i łokcie blisko ciała. Wykorzystaj kontrolowany, płynny ruch do podnoszenia ciężaru.
3. Unikaj machania: Nie używaj impetu do unoszenia ciężaru. Może to niepotrzebnie obciążać plecy i ramiona.
4. Stopniowo zwiększaj ciężar: Zacznij od ciężaru, który jesteś w stanie wygodnie podnieść przez kilka powtórzeń, a następnie stopniowo zwiększaj obciążenie w miarę wzrostu siły.
5. Nie podnoś zbyt ciężko: Nie podnoś ciężaru, który jest zbyt ciężki do kontrolowania. Może to prowadzić do złej formy i zwiększonego ryzyka kontuzji.
6. Słuchaj swojego ciała: Jeśli odczuwasz ból lub dyskomfort, natychmiast przestań podnosić. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Śledząc te kroki, możesz pomóc uniknąć kontuzji podczas wykonywania podbicia bicepsu i upewnić się, że maksymalnie wykorzystujesz swój trening."'''),
      3,
      12),
  Exercise(
      '5',
      'Barbell Overhead\nPress',
      "Wyciskanie\nżołnierskie",
      'Shoulders , Chest , Triceps',
      "Barki , Klatka piersiowa , Triceps",
      true,
      "images/barbellOverHead.jpg",
      CreatingExercisePage(
          5,
          "images/standing-military-press.png",
          "Barbell overhead press is a compound exercise that primarily targets the shoulders and triceps muscles. It involves lifting a barbell from shoulder height to an overhead position while standing or seated.\n\nTo avoid injuries during barbell overhead press, there are several important steps you can take:\n\n1.Warm up properly: Before starting with heavy weights, spend 5-10 minutes doing light cardio, stretching, and practicing the overhead press movement with light weights.\n2.Use proper form: Keep your feet shoulder-width apart, your back straight, and your elbows tucked in. Use a controlled, smooth motion to lift the weight overhead.\n3.Use a grip that works for you: Depending on your flexibility, you can use a wider or narrower grip on the barbell. Experiment to find the grip that feels most comfortable for you.\n4.Gradually increase the weight: Start with a weight that you can handle comfortably for several repetitions, and gradually increase the weight as your strength improves.\n5.Use a spotter: If you're lifting heavy weights, it's important to have a spotter to help you maintain proper form and prevent injury.\n6.Don't hyperextend your back: Avoid arching your back excessively when lifting the weight overhead. This can put unnecessary strain on your lower back and increase the risk of injury.\n7.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during barbell overhead press and ensure that you're getting the most out of your workout.",
          '''Podnoszenie sztangi nad głowę to ćwiczenie wielostawowe, które głównie skupia się na mięśniach barkowych (barki) i tricepsie. Polega na podnoszeniu sztangi z poziomu barków do pozycji nad głową, zarówno w pozycji stojącej, jak i siedzącej.

Aby uniknąć kontuzji podczas podciągania sztangi nad głowę, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Przed rozpoczęciem ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio, rozciąganie i praktykowanie ruchu podciągania sztangi nad głowę z lekkimi obciążeniami.

2. Zachowaj właściwą technikę: Trzymaj stopy na szerokość ramion (barków), plecy proste i łokcie przy ciele. Wykonuj kontrolowany, płynny ruch, aby podnieść ciężar nad głowę.

3. Użyj chwytu odpowiedniego dla siebie: W zależności od swojej elastyczności, możesz stosować szerszy lub węższy chwyt na sztandze. Eksperymentuj, aby znaleźć chwyt, który jest dla ciebie najwygodniejszy.

4. Stopniowo zwiększaj obciążenie: Rozpocznij od ciężaru, który możesz komfortowo podnosić przez kilka powtórzeń, a następnie stopniowo zwiększaj obciążenie w miarę wzrostu siły.

5. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz ciężkie obciążenia, ważne jest, aby mieć osobę asystującą, która pomoże ci utrzymać właściwą technikę i zapobiegnie kontuzjom.

6. Nie nadmiernie wyginaj plecy: Unikaj nadmiernego wygięcia pleców podczas podnoszenia ciężaru nad głowę. To może narażać dolną część pleców na zbędne obciążenie i zwiększyć ryzyko kontuzji.

7. Słuchaj swojego ciała: Jeśli odczuwasz ból lub dyskomfort, natychmiast przerwij podciąganie. Nie forsuj się, ponieważ to może prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas podciągania sztangi nad głowę i upewnić się, że w pełni wykorzystujesz swoje treningi.'''),
      3,
      10),
  Exercise(
      '6',
      'Dumbbell\nOverhead Press',
      "Podnoszenie hantli\nponad głowę",
      'Shoulders',
      "Barki",
      true,
      "images/DumbbellOverheadPress.jpg",
      CreatingExercisePage(
          6,
          "images/DumbbellOverHeadDes.png",
          "Dumbbell overhead press is a compound exercise that primarily targets the shoulders and triceps muscles. It involves lifting a dumbbell from shoulder height to an overhead position while standing or seated.\n\nTo avoid injuries during dumbbell overhead press, there are several important steps you can take:\n\n1.Warm up properly: Before starting with heavy weights, spend 5-10 minutes doing light cardio, stretching, and practicing the overhead press movement with light weights.\n2.Use proper form: Keep your feet shoulder-width apart, your back straight, and your elbows tucked in. Use a controlled, smooth motion to lift the weight overhead.\n3.Use a grip that works for you: Depending on your flexibility, you can use a wider or narrower grip on the dumbbell. Experiment to find the grip that feels most comfortable for you.\n4.Gradually increase the weight: Start with a weight that you can handle comfortably for several repetitions, and gradually increase the weight as your strength improves.\n5.Use a spotter: If you're lifting heavy weights, it's important to have a spotter to help you maintain proper form and prevent injury.\n6.Don't hyperextend your back: Avoid arching your back excessively when lifting the weight overhead. This can put unnecessary strain on your lower back and increase the risk of injury.\n7.Keep your core tight: Engage your core muscles throughout the lift to help stabilize your body and prevent injury.\n8.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during dumbbell overhead press and ensure that you're getting the most out of your workout.",
          '''Wyciskanie hantli nad głowę to ćwiczenie wielostawowe, które głównie koncentruje się na mięśniach barkowych (barki) i tricepsie. Polega na podnoszeniu hantli z poziomu ramion do pozycji nad głową, zarówno w pozycji stojącej, jak i siedzącej.

Aby uniknąć kontuzji podczas wyciskania hantli nad głowę, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Przed rozpoczęciem ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio, rozciąganie i praktykowanie ruchu wyciskania hantli nad głowę z lekkimi obciążeniami.

2. Zachowaj właściwą technikę: Trzymaj stopy na szerokość ramion (barków), plecy proste, a łokcie przyległe do ciała. Wykonuj kontrolowany, płynny ruch, aby podnieść hantle nad głowę.

3. Użyj chwytu odpowiedniego dla siebie: W zależności od swojej elastyczności, możesz stosować szerszy lub węższy chwyt na hantlach. Przeprowadzaj eksperymenty, aby znaleźć chwyt, który jest dla ciebie najwygodniejszy.

4. Stopniowo zwiększaj obciążenie: Rozpocznij od wagi, którą możesz wygodnie podnosić przez kilka powtórzeń, a następnie stopniowo zwiększaj obciążenie w miarę wzrostu siły.

5. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz ciężkie hantle, ważne jest, aby mieć osobę asystującą, która pomoże ci utrzymać właściwą technikę i zapobiegnie kontuzjom.

6. Nie nadmiernie wyginaj plecy: Unikaj nadmiernego wygięcia pleców podczas podnoszenia hantli nad głowę. To może narażać dolną część pleców na zbędne obciążenie i zwiększyć ryzyko kontuzji.

7. Utrzymuj napięcie w mięśniach brzucha: Angażuj mięśnie brzucha przez cały ruch, aby pomóc w stabilizacji ciała i uniknąć kontuzji.

8. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij podnoszenie hantli. Nie forsuj się, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas wyciskania hantli nad głowę i zapewnić, że w pełni wykorzystujesz swój trening.'''),
      3,
      8),
  Exercise(
      '7',
      'Cable Lateral Raises',
      "Wznosy bokiem\nna wyciągu",
      'Shoulders',
      "Barki",
      true,
      "images/CableLateralRises.jpg",
      CreatingExercisePage(
          7,
          "images/LiteralRises.png",
          "Cable lateral raises are a great exercise for targeting the shoulder muscles, particularly the lateral deltoids. It involves using a cable machine to lift weights out to the sides, with your arms straight.\n\n\To avoid injuries during cable lateral raises, there are several important steps you can take:\n1.Warm up properly: Before starting with heavy weights, spend 5-10 minutes doing light cardio, stretching, and practicing the lateral raise movement with light weights.\n2.Use proper form: Keep your feet shoulder-width apart, your back straight, and your elbows slightly bent. Use a controlled, smooth motion to lift the weights out to the sides.\n3.Keep your shoulders down: Avoid shrugging your shoulders as you lift the weights. This can put unnecessary strain on your neck and shoulders.\n4.Gradually increase the weight: Start with a weight that you can handle comfortably for several repetitions, and gradually increase the weight as your strength improves.\n5.Use a spotter: If you're lifting heavy weights, it's important to have a spotter to help you maintain proper form and prevent injury.\n6.Don't swing the weights: Avoid using momentum to swing the weights out to the sides. This can put unnecessary strain on your shoulder joints.\n7.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during cable lateral raises and ensure that you're getting the most out of your workout.",
          '''Podciąganie hantli na maszynie kablowej na boki to doskonałe ćwiczenie do skoncentrowania się na mięśniach barkowych, zwłaszcza mięśniach bocznych mięśnia dwugłowego ramienia. Polega ono na wykorzystaniu maszyny kablowej do unoszenia ciężarów na boki, trzymając ręce prosto.

Aby uniknąć kontuzji podczas podciągania hantli na maszynie kablowej na boki, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Przed rozpoczęciem ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio, rozciąganie i praktykowanie ruchu podciągania hantli na boki z lekkimi obciążeniami.

2. Zachowaj właściwą technikę: Trzymaj stopy na szerokość ramion, plecy proste i łokcie lekko zgięte. Wykonuj kontrolowany, płynny ruch, aby unieść ciężary na boki.

3. Trzymaj ramiona opuszczone: Unikaj podrygiwania ramion podczas unoszenia ciężarów. To może narażać zbędne napięcie na kark i barki.

4. Stopniowo zwiększaj obciążenie: Rozpocznij od wagi, którą możesz wygodnie podnosić przez kilka powtórzeń, a następnie stopniowo zwiększaj obciążenie w miarę wzrostu siły.

5. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz ciężkie obciążenia, ważne jest, aby mieć osobę asystującą, która pomoże ci utrzymać właściwą technikę i zapobiegnie kontuzjom.

6. Nie używaj inercji: Unikaj wykorzystywania impetu do unoszenia ciężarów na boki. To może narażać zbędne obciążenie na stawy barkowe.

7. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij podciąganie. Nie forsuj się, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas podciągania hantli na maszynie kablowej na boki i zapewnić, że w pełni wykorzystujesz swój trening.'''),
      3,
      12),
  Exercise(
      '8',
      'Dumbbell\nLateral Raises',
      "Wznosy bokiem\nhantlami",
      "Shoulders",
      "Barki",
      true,
      "images/DumbbellLateralRaises.jpg",
      CreatingExercisePage(
          8,
          "images/dumbbell-lateral-raise.png",
          "Dumbbell lateral raises are an effective exercise for targeting the shoulder muscles, particularly the lateral deltoids. It involves lifting dumbbells out to the sides with your arms straight.\n\nTo avoid injuries during dumbbell lateral raises, there are several important steps you can take:\n1.Warm up properly: Before starting with heavy weights, spend 5-10 minutes doing light cardio, stretching, and practicing the lateral raise movement with light weights.\n2.Use proper form: Keep your feet shoulder-width apart, your back straight, and your elbows slightly bent. Use a controlled, smooth motion to lift the weights out to the sides.\n3.Keep your shoulders down: Avoid shrugging your shoulders as you lift the weights. This can put unnecessary strain on your neck and shoulders.\n3.Gradually increase the weight: Start with a weight that you can handle comfortably for several repetitions, and gradually increase the weight as your strength improves.\n4.Use a spotter: If you're lifting heavy weights, it's important to have a spotter to help you maintain proper form and prevent injury.\n5.Don't swing the weights: Avoid using momentum to swing the weights out to the sides. This can put unnecessary strain on your shoulder joints.\n6.Don't lift the weights too high: Lifting the weights too high above shoulder level can cause impingement in the shoulder joint. Lift the weights only to shoulder height or slightly below.\n7.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during dumbbell lateral raises and ensure that you're getting the most out of your workout.",
          '''Unoszenie hantli na boki to efektywne ćwiczenie, które skupia się na mięśniach barkowych, zwłaszcza mięśniach bocznych mięśnia dwugłowego ramienia. Polega na uniesieniu hantli na boki, trzymając ramiona prosto.

Aby uniknąć kontuzji podczas unoszenia hantli na boki, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Przed rozpoczęciem ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio, rozciąganie i praktykowanie ruchu unoszenia hantli na boki z lekkimi obciążeniami.

2. Zachowaj właściwą technikę: Trzymaj stopy na szerokość ramion, plecy proste, a łokcie lekko zgięte. Wykonuj kontrolowany, płynny ruch, aby unieść hantle na boki.

3. Trzymaj ramiona opuszczone: Unikaj unoszenia ramion ku górze podczas unoszenia hantli. To może narażać zbędne napięcie na kark i barki.

4. Stopniowo zwiększaj obciążenie: Rozpocznij od wagi, którą możesz wygodnie podnosić przez kilka powtórzeń, a następnie stopniowo zwiększaj obciążenie w miarę wzrostu siły.

5. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz ciężkie hantle, ważne jest, aby mieć osobę asystującą, która pomoże ci utrzymać właściwą technikę i zapobiegnie kontuzjom.

6. Nie używaj inercji: Unikaj wykorzystywania impetu, aby unoszenie hantli. To może narażać zbędne obciążenie na stawy barkowe.

7. Nie unoś hantli zbyt wysoko: Unoszenie hantli zbyt wysoko ponad poziom barków może prowadzić do ucisku w stawie barkowym. Unosź hantle tylko do poziomu barków lub nieco poniżej.

8. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij unoszenie hantli. Nie forsuj się, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas unoszenia hantli na boki i zapewnić, że w pełni wykorzystujesz swój trening.'''),
      3,
      12),
  Exercise(
      '9',
      'Hip Thrust',
      "Hip Thrust",
      "Glutes , Hamstrings, Quadriceps",
      "Pośladki , Czworogłowy, Dwugłowy",
      false,
      "images/HipThrust.jpg",
      CreatingExercisePage(
          9,
          "images/HipThrust.png",
          "Hip thrusts are a great exercise for targeting the glute muscles and building lower body strength. They involve lifting a barbell or weight up off the ground with your hips and glutes.\n\nTo avoid injuries during hip thrusts, there are several important steps you can take:\n1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.\n2.Use proper form: Keep your feet flat on the ground, your knees bent, and your shoulders and upper back against a bench or elevated surface. Use your glutes and hamstrings to lift the weight up, rather than arching your back or using your lower back muscles.\n3.Start with lighter weights: Begin with lighter weights and gradually increase the weight as your strength improves.\n4.Use a pad or towel: Place a pad or folded towel between the bar and your hips to prevent discomfort or bruising.\n5.Breathe properly: Inhale deeply before lifting the weight, then exhale as you lift. Inhale again as you lower the weight, and exhale as you return to the starting position.\n6.Avoid hyperextension: Do not hyperextend your back or lift the weight too high. This can put unnecessary strain on your lower back and increase the risk of injury.\n7.Don't push through pain: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during hip thrusts and ensure that you're getting the most out of your workout.",
          '''Wypychania bioder są doskonałym ćwiczeniem do koncentracji na mięśniach pośladkowych i budowania siły dolnej partii ciała. Polegają na podnoszeniu sztangi lub obciążenia z podłogi za pomocą bioder i mięśni pośladkowych.

Aby uniknąć kontuzji podczas wykonywania wypychania bioder, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj stopy płasko na ziemi, kolana zgięte, a ramiona i górną część pleców oparte o ławkę lub podwyższenie. Wykorzystuj mięśnie pośladkowe i łydki do podnoszenia ciężaru, zamiast wyginania pleców lub używania mięśni dolnej części pleców.

3. Rozpocznij od mniejszych obciążeń: Zacznij od mniejszych ciężarów i stopniowo zwiększaj je w miarę wzrostu siły.

4. Użyj podkładki lub ręcznika: Umieść podkładkę lub złożony ręcznik między sztangą a biodrami, aby uniknąć dyskomfortu lub siniaków.

5. Prawidłowe oddychanie: Wdychaj głęboko przed podniesieniem ciężaru, a następnie wydychaj powietrze podczas podnoszenia. Wdychaj ponownie podczas opuszczania ciężaru i wydychaj powietrze wracając do pozycji wyjściowej.

6. Unikaj nadmiernego wygięcia pleców: Nie nadmiernie wyginaj plecy ani nie podnosź ciężaru zbyt wysoko. To może narażać dolną część pleców na zbędne obciążenie i zwiększyć ryzyko kontuzji.

7. Nie forsuj bólu: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie próbuj forsować się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas wypychania bioder i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      4,
      8),
  Exercise(
      '10',
      'French\nPress',
      'Wyciskanie\nFrancuskie',
      "Triceps",
      "Triceps",
      true,
      "images/FrenchPresss.png",
      CreatingExercisePage(
          10,
          "images/FrenchPresss.png",
          "French press, also known as skull crushers, is a popular exercise for targeting the triceps muscles. It involves lifting a barbell or dumbbells up and down behind the head while lying on a bench or flat surface.\n\n\To avoid injuries during French press, there are several important steps you can take:\n1.Warm up properly: Before starting with heavy weights, spend 5-10 minutes doing light cardio, stretching, and practicing the French press movement with light weights.\n2.Use proper form: Keep your elbows in, your upper arms stationary, and your wrists straight. Use a controlled, smooth motion to lower the weight down behind your head and then lift it back up.\n3.Gradually increase the weight: Start with a weight that you can handle comfortably for several repetitions, and gradually increase the weight as your strength improves.\n4.Use a spotter: If you're lifting heavy weights, it's important to have a spotter to help you maintain proper form and prevent injury.\n5.Avoid locking out your elbows: Do not fully extend your elbows at the top of the movement, as this can put unnecessary strain on your elbow joints.\n6.Don't lower the weight too far: Lower the weight only as far as you can without feeling discomfort or pain in your elbows or shoulders. Lowering the weight too far behind your head can cause shoulder impingement or elbow strain.\n7.Listen to your body: If you feel any pain or discomfort, stop lifting immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during French press and ensure that you're getting the most out of your workout.",
          '''Wyciskanie francuskie, znane również jako "skull crushers", to popularne ćwiczenie do koncentracji na mięśniach tricepsów. Polega na podnoszeniu sztangi lub hantli w górę i w dół za głową, leżąc na ławce lub płaskiej powierzchni.

Aby uniknąć kontuzji podczas wyciskania francuskiego, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Przed rozpoczęciem ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio, rozciąganie i praktykowanie ruchu wyciskania francuskiego z lekkimi obciążeniami.

2. Zachowaj właściwą technikę: Trzymaj łokcie przy ciele, górne ramiona nieruchome, a nadgarstki proste. Wykonuj kontrolowany, płynny ruch, aby opuszczać ciężar za głowę, a następnie unosić go z powrotem.

3. Stopniowo zwiększaj obciążenie: Rozpocznij od ciężaru, który możesz wygodnie podnosić przez kilka powtórzeń, a następnie stopniowo zwiększaj obciążenie w miarę wzrostu siły.

4. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz ciężkie obciążenia, ważne jest, aby mieć osobę asystującą, która pomoże utrzymać właściwą technikę i zapobiegnie kontuzjom.

5. Unikaj blokowania łokci: Nie prostuj całkowicie łokci na górze ruchu, ponieważ może to narażać zbędne obciążenie stawów łokciowych.

6. Nie opuszczaj ciężaru zbyt nisko: Opuszczaj ciężar tylko tak nisko, jak to jest możliwe bez odczuwania dyskomfortu lub bólu w łokciach lub barkach. Opuszczanie ciężaru zbyt nisko za głowę może prowadzić do ucisku w stawie barkowym lub napięcia w stawie łokciowym.

7. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij podnoszenie ciężaru. Nie forsuj się, ponieważ to może prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas wyciskania francuskiego i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      2,
      14),
  Exercise(
      '11',
      'Dumbbell flys',
      "Rozpiętki",
      "Chest",
      "Klatka piersiowa",
      true,
      "images/DumbbellFlys.jpg",
      CreatingExercisePage(
          11,
          "images/images/DumbbellFlyyy.png",
          "Dumbbell flys are a popular exercise for targeting the chest muscles. They involve lifting dumbbells up and down in a wide arc motion while lying on a bench or flat surface.\n\nTo avoid injuries during dumbbell flys, there are several important steps you can take:\n1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.\n2.Use proper form: Keep your elbows slightly bent, your wrists straight, and your shoulders and upper back pressed firmly against the bench. Use a controlled, smooth motion to lift and lower the dumbbells in a wide arc motion.\n3.Start with lighter weights: Begin with lighter weights and gradually increase the weight as your strength improves.\n4.Don't go too heavy: Do not lift weights that are too heavy, as this can cause undue strain on your chest muscles and increase the risk of injury.\n5.Breathe properly: Inhale deeply before lifting the weight, then exhale as you lift. Inhale again as you lower the weight, and exhale as you return to the starting position.\n6.Avoid hyperextension: Do not lower the weight too far down, as this can put unnecessary strain on your shoulder joints and increase the risk of injury.\n7.Don't push through pain: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during dumbbell flys and ensure that you're getting the most out of your workout.",
          '''Półleżące wyciskanie hantli to popularne ćwiczenie, które koncentruje się na mięśniach klatki piersiowej. Polega na podnoszeniu hantli w górę i w dół w szerokim ruchu łukowatym, leżąc na ławce lub płaskiej powierzchni.

Aby uniknąć kontuzji podczas wykonywania półleżącego wyciskania hantli, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Przed rozpoczęciem ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj łokcie lekko zgięte, nadgarstki proste, a ramiona i górną część pleców mocno oparte na ławce. Wykonuj kontrolowany, płynny ruch, aby unosić i opuszczać hantle w szerokim ruchu łukowatym.

3. Rozpocznij od mniejszych obciążeń: Zacznij od mniejszych ciężarów i stopniowo zwiększaj je w miarę wzrostu siły.

4. Nie przesadzaj z ciężarem: Nie podnoś ciężarów, które są zbyt ciężkie, ponieważ to może spowodować nadmierne obciążenie mięśni klatki piersiowej i zwiększyć ryzyko kontuzji.

5. Prawidłowe oddychanie: Wdychaj głęboko przed podniesieniem ciężaru, a następnie wydychaj powietrze podczas podnoszenia. Wdychaj ponownie podczas opuszczania ciężaru, a następnie wydychaj powietrze wracając do pozycji wyjściowej.

6. Unikaj nadmiernego opuszczania ciężaru: Nie opuszczaj ciężaru zbyt nisko, ponieważ to może narażać zbędne obciążenie na stawy barkowe i zwiększyć ryzyko kontuzji.

7. Nie forsuj bólu: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie próbuj forsować się przez ból, ponieważ to może prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas półleżącego wyciskania hantli i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      2,
      12),
  Exercise(
      '12',
      'Zercher\nSquat',
      'Przysiady\nZerchera',
      "Hamstrings , Glutes",
      "Dwugłowy , Pośladki",
      true,
      "images/ZercherSquat.jpg",
      CreatingExercisePage(
          12,
          "images/Zercher.png",
          "Zercher squats are a type of squat exercise where the barbell is held in the crook of the elbows rather than on the back. They are an effective way to target the lower body muscles and improve overall strength.\n\nTo avoid injuries during Zercher squats, there are several important steps you can take:\n1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.\n2.Use proper form: Keep your feet shoulder-width apart and your toes pointing slightly outward. Keep your chest up and your back straight. Use a controlled, smooth motion to lower yourself down into a squat and then push back up to the starting position.\n3.Start with lighter weights: Begin with lighter weights and gradually increase the weight as your strength improves.\n4.Use a squat pad: Place a squat pad or towel around the barbell to cushion your elbows and prevent bruising.\n5.Keep your elbows in: Keep your elbows in to prevent the barbell from slipping and causing injury.\n6/Use a spotter: If you're lifting heavy weights, it's important to have a spotter to help you maintain proper form and prevent injury.\n7.Don't go too low: Do not lower yourself down too far, as this can cause undue strain on your knees and increase the risk of injury.\n8.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these steps, you can help prevent injuries during Zercher squats and ensure that you're getting the most out of your workout.",
          '''Przysiady Zercher to rodzaj ćwiczenia przysiadu, w którym sztanga trzymana jest w zgięciu łokci zamiast na plecach. Są one skutecznym sposobem na koncentrację na mięśniach dolnej partii ciała i poprawę ogólnej siły.

Aby uniknąć kontuzji podczas przysiadów Zercher, istnieje kilka istotnych kroków, które możesz podjąć:

1. Rozgrzewka: Przed rozpoczęciem ciężkich obciążeń, poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj stopy na szerokość ramion, a palce stóp skierowane nieco na zewnątrz. Trzymaj klatkę piersiową wyprostowaną i plecy proste. Wykonuj kontrolowany, płynny ruch, aby opuścić się w przysiad i wrócić do pozycji wyjściowej.

3. Rozpocznij od mniejszych obciążeń: Zacznij od mniejszych ciężarów i stopniowo zwiększaj je w miarę wzrostu siły.

4. Użyj ochraniacza na sztangę: Umieść ochraniacz na sztandze lub ręcznik wokół sztangi, aby amortyzować łokcie i zapobiec siniakom.

5. Trzymaj łokcie blisko ciała: Trzymaj łokcie blisko ciała, aby uniknąć ześlizgnięcia się sztangi i kontuzji.

6. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz ciężkie obciążenia, ważne jest, aby mieć osobę asystującą, która pomoże utrzymać właściwą technikę i zapobiegnie kontuzjom.

7. Nie schodź zbyt nisko: Nie opuszczaj się zbyt nisko, ponieważ to może powodować nadmierne obciążenie kolan i zwiększyć ryzyko kontuzji.

8. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas przysiadów Zercher i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      3,
      10),
  Exercise(
      '13',
      'Triceps\nExtension',
      "Triceps\nExtension",
      "Triceps",
      "Triceps",
      true,
      "images/TricepsExtension.jpg",
      CreatingExercisePage(
          13,
          "images/TricepExtensionn.png",
          "Triceps extensions are a popular exercise that target the triceps muscles on the back of the arm. To avoid injuries during triceps extensions, it's important to use proper form and technique.\n\nHere are some tips to help you avoid injury:\n1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.\n2.Use proper form: Keep your back straight and your elbows close to your head. Lower the weight slowly behind your head, keeping your elbows stationary. Then, lift the weight back up to the starting position.\n3.Start with lighter weights: Begin with lighter weights and gradually increase the weight as your strength improves.\n4.Use a spotter: If you're lifting heavy weights, it's important to have a spotter to help you maintain proper form and prevent injury.\n5.Don't overextend: Avoid extending your arms too far at the top of the movement, as this can cause undue strain on your elbows and increase the risk of injury.\n6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.\n\nBy following these tips, you can help prevent injuries during triceps extensions and get the most out of your workout.",
          '''Rozciąganie tricepsów to popularne ćwiczenie, które koncentruje się na mięśniach tricepsów na tyle ręki. Aby uniknąć kontuzji podczas rozciągania tricepsów, ważne jest zachowanie właściwej formy i techniki.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj plecy proste i łokcie blisko głowy. Powoli opuszczaj ciężar za głowę, utrzymując łokcie nieruchome. Następnie unieś ciężar z powrotem do pozycji wyjściowej.

3. Rozpocznij od mniejszych obciążeń: Zacznij od mniejszych ciężarów i stopniowo zwiększaj obciążenie w miarę wzrostu siły.

4. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz ciężkie obciążenia, ważne jest, aby mieć osobę asystującą, która pomoże utrzymać właściwą technikę i zapobiegnie kontuzjom.

5. Nie przesadzaj z wyprostowaniem ramion: Unikaj nadmiernego wyprostowania ramion na górze ruchu, ponieważ może to spowodować nadmierne obciążenie stawów łokciowych i zwiększyć ryzyko kontuzji.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas rozciągania tricepsów i osiągnąć maksimum korzyści ze swojego treningu.'''),
      3,
      12),
  Exercise(
      '14',
      'Dip',
      "Pompki na poręczach",
      "Tricpes , Chest",
      "Tricpes , Klatka piersiowa",
      false,
      "images/dip.jpg",
      CreatingExercisePage(
          14,
          "images/DIP.png",
          '''Dips are a great exercise that target the triceps, chest, and shoulders. However, they can put a lot of strain on the shoulders if not done correctly. To avoid injuries during dips, it's important to use proper form and technique.\n\n
      Here are some tips to help you avoid injury:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.\n
      2.Use proper form: Keep your elbows close to your body and your shoulders down. Lower your body until your arms form a 90-degree angle, and then push back up to the starting position.\n
      3.Start with assistance: If you're a beginner or not yet strong enough to do dips on your own, use an assisted dip machine or resistance bands to help you.\n
      4.Use a spotter: If you're lifting heavy weights or doing weighted dips, it's important to have a spotter to help you maintain proper form and prevent injury.\n
      5.Don't go too low: Avoid going too low during the exercise, as this can cause undue strain on your shoulders and increase the risk of injury.\n
      6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.\n\n
      By following these tips, you can help prevent injuries during dips and ensure that you're getting the most out of your workout.''',
          '''Pompki na poręczach to doskonałe ćwiczenie, które koncentruje się na mięśniach tricepsów, klatki piersiowej i ramion. Jednak mogą one wywierać duże obciążenie na barki, jeśli nie są wykonywane poprawnie. Aby uniknąć kontuzji podczas wykonywania pompki na poręczach, ważne jest zachowanie właściwej formy i techniki.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj łokcie blisko ciała i barki w dół. Opuszczaj ciało, aż ramiona utworzą kąt prosty, a następnie pchnij się w górę do pozycji wyjściowej.

3. Zacznij z pomocą: Jeśli jesteś początkujący lub nie masz jeszcze wystarczającej siły, aby wykonać pompki na poręczach samodzielnie, skorzystaj z maszyny do wspomaganego wykonywania pompki lub gumy oporowej, która pomoże ci w ćwiczeniu.

4. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz duże obciążenia lub wykonujesz obciążone pompki, ważne jest, aby mieć osobę asystującą, która pomoże utrzymać właściwą technikę i zapobiegnie kontuzjom.

5. Nie opuszczaj się zbyt nisko: Unikaj zbyt głębokiego opuszczania ciała w trakcie ćwiczenia, ponieważ to może powodować nadmierne obciążenie barków i zwiększyć ryzyko kontuzji.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas wykonywania pompki na poręczach i osiągnąć maksimum korzyści ze swojego treningu.'''),
      2,
      10),
  Exercise(
      '15',
      'Bench Dip',
      "Odwrotne\npompki",
      "Triceps",
      "Triceps",
      false,
      "images/BenchDip.jpg",
      CreatingExercisePage(
          15,
          "images/BenchDip.png",
          '''Bench dips are a great exercise for targeting the triceps, but they can also put strain on the shoulders and wrists if done improperly. To avoid injuries during bench dips, it's important to use proper form and technique.
      
      Here are some tips to help you avoid injury:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.
      
      2.Use proper form: Keep your shoulders down and your elbows close to your body. Lower your body until your arms form a 90-degree angle, and then push back up to the starting position.
      
      3.Use a stable bench: Use a stable bench or chair that won't move or wobble during the exercise.
      
      4.Don't go too low: Avoid going too low during the exercise, as this can cause undue strain on your shoulders and wrists.
      
      5.Use a spotter: If you're lifting heavy weights or doing weighted bench dips, it's important to have a spotter to help you maintain proper form and prevent injury.
      
      6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      
      By following these tips, you can help prevent injuries during bench dips and ensure that you're getting the most out of your workout.''',
          '''Pompki na ławce to doskonałe ćwiczenie, które koncentruje się na mięśniach tricepsów, ale mogą również wywierać obciążenie na barki i nadgarstki, jeśli są wykonywane niewłaściwie. Aby uniknąć kontuzji podczas wykonywania pompki na ławce, ważne jest zachowanie właściwej formy i techniki.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj barki opuszczone i łokcie blisko ciała. Opuszczaj ciało, aż ramiona utworzą kąt prosty, a następnie pchnij się w górę do pozycji wyjściowej.

3. Użyj stabilnej ławki: Skorzystaj z stabilnej ławki lub krzesła, które nie będzie się ruszać ani chwiać podczas ćwiczenia.

4. Nie opuszczaj się zbyt nisko: Unikaj zbyt głębokiego opuszczania ciała w trakcie ćwiczenia, ponieważ może to powodować nadmierne obciążenie barków i nadgarstków.

5. Skorzystaj z osoby asystującej (spottera): Jeśli podnosisz duże obciążenia lub wykonujesz obciążone pompki na ławce, ważne jest, aby mieć osobę asystującą, która pomoże utrzymać właściwą technikę i zapobiegnie kontuzjom.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas wykonywania pompki na ławce i osiągnąć maksimum korzyści ze swojego treningu.'''),
      3,
      16),
  Exercise(
      '16',
      'Back\nExtension',
      "Unoszenie\ntułowia",
      "Lats",
      "Plecy",
      true,
      "images/backExtension.jpg",
      CreatingExercisePage(
          16,
          "images/BAckkkextension.png",
          '''Back extensions are an excellent exercise for targeting the lower back muscles. However, they can also put a lot of stress on the spine if done improperly. To avoid injuries during back extensions, it's important to use proper form and technique.
      
      Here are some tips to help you avoid injury:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.
      
      2.Use proper form: Keep your back straight and your movements slow and controlled. Don't arch your back or jerk your body during the exercise.
      
      3.Don't overextend: Avoid overextending your back during the exercise, as this can put unnecessary stress on your spine.
      
      4.Use a mat: If you're doing back extensions on the floor, use a mat or towel to cushion your lower back and prevent injury.
      
      5.Start with a low weight or bodyweight: If you're new to back extensions or not yet strong enough to use weights, start with a low weight or bodyweight.
      
      6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.\n
      
      By following these tips, you can help prevent injuries during back extensions and ensure that you're getting the most out of your workout.''',
          '''Podnoszenie tułowia to doskonałe ćwiczenie, które koncentruje się na mięśniach dolnej części pleców. Jednak może ono wywierać duży nacisk na kręgosłup, jeśli nie jest wykonywane właściwie. Aby uniknąć kontuzji podczas podnoszenia tułowia, ważne jest zachowanie właściwej formy i techniki.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj plecy proste i wykonuj ruchy powoli i kontrolowane. Nie wyginaj pleców ani nie wykonuj gwałtownych ruchów ciałem w trakcie ćwiczenia.

3. Nie nadmiernie wyginać: Unikaj nadmiernego wyginania pleców podczas ćwiczenia, ponieważ może to spowodować nadmierne obciążenie kręgosłupa.

4. Użyj maty: Jeśli wykonujesz podnoszenie tułowia na podłodze, użyj maty lub ręcznika, aby amortyzować dolną część pleców i zapobiec kontuzjom.

5. Zacznij od niskiego ciężaru lub własnej wagi ciała: Jeśli jesteś początkujący w podnoszeniu tułowia lub nie masz jeszcze wystarczającej siły, aby korzystać z obciążeń, zacznij od niskiego ciężaru lub własnej wagi ciała.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas podnoszenia tułowia i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      2,
      16),
  Exercise(
      '17',
      'Barbell Row',
      "Wiosłowanie\nsztangą",
      "Lats",
      "Plecy",
      true,
      "images/barbellRow.jpg",
      CreatingExercisePage(
          17,
          "images/BarbellRoww.png",
          '''Barbell rows are a great exercise for targeting the back muscles, but they can also put strain on the lower back if done improperly. To avoid injuries during barbell rows, it's important to use proper form and technique.
      
      Here are some tips to help you avoid injury:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.
      
      2.Use proper form: Keep your back straight and your movements slow and controlled. Don't round your back or jerk your body during the exercise.
      
      3.Use a grip that feels comfortable: Use a grip that feels comfortable to you, whether it be an overhand or underhand grip.
      
      4.Use proper weights: Use weights that are appropriate for your fitness level and strength. Don't try to lift too heavy too quickly.
      
      5.Keep your core tight: Engage your core muscles during the exercise to help support your lower back.
      
      6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during barbell rows and ensure that you're getting the most out of your workout.''',
          '''Wiosłowanie sztangą to doskonałe ćwiczenie, które koncentruje się na mięśniach pleców, ale może wywierać nacisk na dolną część pleców, jeśli nie jest wykonywane właściwie. Aby uniknąć kontuzji podczas wykonywania wiosłowania sztangą, ważne jest zachowanie właściwej formy i techniki.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj plecy proste i wykonuj ruchy powoli i kontrolowane. Nie zaokrąglaj pleców ani nie wykonuj gwałtownych ruchów ciałem w trakcie ćwiczenia.

3. Użyj chwytu, który jest dla ciebie wygodny: Skorzystaj z chwytu, który jest dla ciebie wygodny, czy to będzie chwyt nad- czy podhadowy.

4. Użyj odpowiednich obciążeń: Używaj obciążeń odpowiednich dla swojego poziomu kondycji i siły. Nie próbuj podnosić zbyt dużych ciężarów zbyt szybko.

5. Zachowaj napięcie w mięśniach brzucha: Angażuj mięśnie brzucha w trakcie ćwiczenia, aby wspierać dolną część pleców.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas wykonywania wiosłowania sztangą i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      3,
      8),
  Exercise(
      '18',
      'Bent Over\nDumbbell',
      "Wiosłowanie\nhantlem",
      "Lats",
      "Plecy",
      true,
      "images/DumbellRow.jpg",
      CreatingExercisePage(
        18,
        "images/BentOverr.png",
        '''Bent over dumbbell rows are a great exercise for targeting the back muscles, but they can also put strain on the lower back if done improperly. To avoid injuries during bent over dumbbell rows, it's important to use proper form and technique.
      
      Here are some tips to help you avoid injury:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.
      
      2,Use proper form: Keep your back straight and your movements slow and controlled. Don't round your back or jerk your body during the exercise.
      
      3.Use a grip that feels comfortable: Use a grip that feels comfortable to you, whether it be an overhand or underhand grip.
      
      4.Use proper weights: Use weights that are appropriate for your fitness level and strength. Don't try to lift too heavy too quickly.
      
      5.Keep your core tight: Engage your core muscles during the exercise to help support your lower back.
      
      6.Don't go too low: Avoid going too low during the exercise as this can put unnecessary stress on your lower back.
      
      7.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during bent over dumbbell rows and ensure that you're getting the most out of your workout.''',
        '''Pochylenie się i wiosłowanie hantlami to doskonałe ćwiczenie, które koncentruje się na mięśniach pleców, ale może wywierać nacisk na dolną część pleców, jeśli nie jest wykonywane właściwie. Aby uniknąć kontuzji podczas wykonywania tego ćwiczenia, ważne jest zachowanie właściwej formy i techniki.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj plecy proste i wykonuj ruchy powoli i kontrolowane. Nie zaokrąglaj pleców ani nie wykonuj gwałtownych ruchów ciałem w trakcie ćwiczenia.

3. Użyj chwytu, który jest dla ciebie wygodny: Skorzystaj z chwytu, który jest dla ciebie wygodny, czy to będzie chwyt nad- czy podhadowy.

4. Użyj odpowiednich obciążeń: Używaj obciążeń odpowiednich dla swojego poziomu kondycji i siły. Nie próbuj podnosić zbyt dużych ciężarów zbyt szybko.

5. Zachowaj napięcie w mięśniach brzucha: Angażuj mięśnie brzucha w trakcie ćwiczenia, aby wspierać dolną część pleców.

6. Nie schylaj się zbyt głęboko: Unikaj nadmiernego schylania się podczas ćwiczenia, ponieważ może to spowodować nadmierne obciążenie dolnej części pleców.

7. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych zasad, możesz pomóc uniknąć kontuzji podczas wykonywania pochylenia się i wiosłowania hantlami oraz upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.''',
      ),
      2,
      8),
  Exercise(
      '19',
      'Blugarian\nSplit Squat',
      "Przysiady\nbułgarskie",
      "Quadriceps , Glutes",
      "Czworogłowe, Pośladki",
      true,
      "images/BlugarianSplitSquat.jpg",
      CreatingExercisePage(
          19,
          "images/BlugarianSplitSquat-PhotoRoom.png-PhotoRoom.png",
          '''Bulgarian split squats are a challenging exercise that can help strengthen the legs and glutes. However, it's important to use proper form and technique to avoid injuries.

Here are some tips to help you avoid injury during Bulgarian split squats:

1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.

2.Use proper form: Keep your back straight and your movements slow and controlled. Keep your front knee in line with your ankle and don't let it go past your toes. Don't let your back knee touch the ground.

3.Use proper weights: Use weights that are appropriate for your fitness level and strength. Don't try to lift too heavy too quickly.

4.Keep your core tight: Engage your core muscles during the exercise to help support your lower back.

5.Balance your weight: Make sure your weight is evenly distributed between your front and back legs. Don't lean too far forward or backward.

6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.

By following these tips, you can help prevent injuries during Bulgarian split squats and ensure that you're getting the most out of your workout.''',
          '''Bułgarskie przysiady to wymagające ćwiczenie, które może pomóc w wzmocnieniu nóg i pośladków. Jednak ważne jest, aby zachować właściwą formę i technikę, aby uniknąć kontuzji.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji podczas wykonywania bułgarskich przysiadów:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj plecy proste i wykonuj ruchy powoli i kontrolowane. Upewnij się, że kolano przodu pozostaje w linii z kostką i nie przekracza palców u stóp. Nie pozwalaj, aby kolano tylne dotknęło ziemi.

3. Użyj odpowiednich obciążeń: Używaj obciążeń odpowiednich dla swojego poziomu kondycji i siły. Nie próbuj podnosić zbyt dużych ciężarów zbyt szybko.

4. Zachowaj napięcie w mięśniach brzucha: Angażuj mięśnie brzucha podczas ćwiczenia, aby wspierać dolną część pleców.

5. Zrównoważ wagę ciała: Upewnij się, że waga jest równomiernie rozłożona między przednią a tylną nogą. Nie pochylaj się zbyt mocno do przodu ani do tyłu.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas bułgarskich przysiadów i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      3,
      12),
  Exercise(
      '20',
      'Cable Crunch',
      "Allachy",
      "Abdomeinals",
      "Brzuch",
      true,
      "images/CableCrunch.jpg",
      CreatingExercisePage(
          20,
          "images/CableCrunch1.png",
          '''Cable crunches are a popular exercise that can help strengthen the abHomeinal muscles. However, it's important to use proper form and technique to avoid injuries.
      
      Here are some tips to help you avoid injury during cable crunches:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.
      
      2.Use proper form: Keep your back straight and your movements slow and controlled. Don't pull with your neck or use momentum to lift the weight.
      
      3.Use proper weights: Use weights that are appropriate for your fitness level and strength. Don't try to lift too heavy too quickly.
      
      4.Keep your core tight: Engage your core muscles during the exercise to help support your lower back.
      
      5.Don't overextend: Avoid overextending your spine during the exercise, as this can lead to injury. Only go as far as you can while maintaining proper form.
      
      6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during cable crunches and ensure that you're getting the most out of your workout.''',
          '''Kokosy na wyciągu to popularne ćwiczenie, które może pomóc w wzmacnianiu mięśni brzucha. Jednak ważne jest, aby zachować właściwą formę i technikę, aby uniknąć kontuzji.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji podczas kokosów na wyciągu:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj plecy proste i wykonuj ruchy powoli i kontrolowane. Nie przyciągaj kablem za pomocą szyi ani nie używaj impetu do podnoszenia obciążenia.

3. Użyj odpowiednich obciążeń: Korzystaj z obciążeń odpowiednich dla swojego poziomu kondycji i siły. Nie próbuj podnosić zbyt ciężkich ciężarów zbyt szybko.

4. Zachowaj napięcie w mięśniach brzucha: Angażuj mięśnie brzucha podczas ćwiczenia, aby wspierać dolną część pleców.

5. Nie nadmiernie wyginaj kręgosłup: Unikaj nadmiernego wyginania kręgosłupa podczas ćwiczenia, ponieważ może to prowadzić do kontuzji. Idź tylko tak daleko, ile jesteś w stanie zachować właściwą formę.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas kokosów na wyciągu i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      2,
      14),
  Exercise(
      '21',
      'Face Pull',
      'Face Pull',
      "Shoulders , Lats",
      "Braki, Plecy",
      true,
      "images/FacePull.png",
      CreatingExercisePage(
        21,
        "images/cable-face-pull-muscles-1024x482.png",
        '''Face pulls are a great exercise for strengthening the rear deltoids, upper back, and shoulder muscles. However, it's important to use proper form and technique to avoid injuries.
      
      Here are some tips to help you avoid injury during face pulls:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.
      
      2.Use proper form: Keep your back straight and your movements slow and controlled. Pull the cable towards your face, keeping your elbows high and your wrists straight.
      
      3.Use proper weights: Use weights that are appropriate for your fitness level and strength. Don't try to lift too heavy too quickly.
      
      4.Keep your core tight: Engage your core muscles during the exercise to help support your lower back.
      
      5.Don't jerk the weight: Avoid jerking the weight or using momentum to complete the exercise. This can lead to injury.
      
      6.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during face pulls and ensure that you're getting the most out of your workout.''',
        '''Face pull na wyciągu to doskonałe ćwiczenie wzmacniające mięśnie tylnej części barków, mięśnie górnej części pleców oraz mięśnie ramion. Jednak aby uniknąć kontuzji, ważne jest zachowanie właściwej formy i techniki.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji podczas kokosów na wyciągu:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Trzymaj plecy proste i wykonuj ruchy powoli i kontrolowane. Pociągnij linkę w kierunku twarzy, trzymając łokcie wysoko i nadgarstki proste.

3. Użyj odpowiednich obciążeń: Wybieraj ciężary odpowiednie dla swojego poziomu sprawności i siły. Nie próbuj podnosić zbyt ciężkich ciężarów zbyt szybko.

4. Utrzymuj napięcie w mięśniach rdzenia: Angażuj mięśnie brzucha podczas ćwiczenia, aby wesprzeć dolną część pleców.

5. Nie szarpuj ciężaru: Unikaj gwałtownych ruchów i nie korzystaj z impetu, aby zakończyć ćwiczenie. Może to prowadzić do kontuzji.

6. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas kokosów na wyciągu i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.''',
      ),
      3,
      12),
  Exercise(
      '22',
      'Cable Twist',
      "Antyrotacja",
      "Obliques",
      "Skośne brzucha",
      true,
      "images/CableTwist.jpg",
      CreatingExercisePage(
          22,
          "images/CableTwist112.png",
          '''Cable twists are an effective exercise for strengthening your core muscles, particularly your obliques. However, like any exercise, it's important to use proper form and technique to avoid injuries.
      
      Here are some tips to help you avoid injury during cable twists:
      
      1.Warm up properly: Spend 5-10 minutes doing light cardio and stretching to prepare your muscles for the exercise.
      
      2.Use proper form: Stand with your feet shoulder-width apart, holding the cable handle at chest height. Slowly twist your torso to one side, keeping your hips facing forward, and then twist back to the center. Repeat on the other side.
      
      3.Use proper weights: Use weights that are appropriate for your fitness level and strength. Don't try to lift too heavy too quickly.
      
      4.Keep your core tight: Engage your core muscles during the exercise to help support your lower back.
      
      5.Avoid hyperextension: Don't twist too far or too quickly, as this can cause hyperextension in your spine.
      
      6.Keep your hips stable: Avoid moving your hips or tilting them to one side during the exercise. This can lead to muscle imbalances and injury.
      
      7.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during cable twists and ensure that you're getting the most out of your workout.''',
          '''Skręty na wyciągu to skuteczne ćwiczenie wzmacniające mięśnie brzucha, zwłaszcza mięśnie skośne. Jednak, jak w przypadku każdego ćwiczenia, ważne jest zachowanie właściwej formy i techniki, aby uniknąć kontuzji.

Oto kilka wskazówek, które pomogą ci uniknąć kontuzji podczas skrętów na wyciągu:

1. Rozgrzewka: Poświęć 5-10 minut na lekkie cardio i rozciąganie, aby przygotować mięśnie do ćwiczenia.

2. Zachowaj właściwą technikę: Stań w rozkroku, trzymając uchwyt wyciągu na wysokości klatki piersiowej. Powoli skręć tułów w jednym kierunku, zachowując biodra zwrócone na wprost, a następnie wróć na środek. Powtórz to samo na drugą stronę.

3. Użyj odpowiednich obciążeń: Wybieraj ciężary odpowiednie dla swojego poziomu sprawności i siły. Nie próbuj podnosić zbyt ciężkich ciężarów zbyt szybko.

4. Utrzymuj napięcie w mięśniach rdzenia: Angażuj mięśnie brzucha podczas ćwiczenia, aby wesprzeć dolną część pleców.

5. Unikaj nadmiernego wygięcia: Nie przekręcaj się zbyt daleko ani zbyt szybko, ponieważ może to prowadzić do nadmiernego wygięcia kręgosłupa.

6. Stabilizuj biodra: Unikaj przesuwania bioder lub przechylania ich na jedną stronę podczas ćwiczenia. Może to prowadzić do nierównowagi mięśniowej i kontuzji.

7. Słuchaj swojego ciała: Jeśli odczuwasz jakikolwiek ból lub dyskomfort, natychmiast przerwij ćwiczenie. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas skrętów na wyciągu i upewnić się, że w pełni wykorzystujesz swoje ćwiczenia.'''),
      3,
      18),
  Exercise(
      '23',
      'Power Clean',
      "Zarzut sztangi",
      "Hamsrtings , Glutes",
      "Dwugłowe, Pośladki",
      true,
      "images/PowerClean.jpg",
      CreatingExercisePage(
          23,
          "images/power-clean-muscles.png",
          '''The power clean is a complex exercise that requires proper technique and form to avoid injuries. It is a compound movement that involves lifting a barbell from the ground to shoulder height, using a combination of strength, speed, and coordination.
      
      Here are some tips to help you avoid injury during power cleans:
      
      1.Warm up properly: Spend 10-15 minutes doing dynamic stretches and mobility exercises to prepare your body for the movement.
      
      2.Use proper form: Begin with your feet hip-width apart, keeping your back straight and your knees bent. Use an overhand grip on the bar and lift it off the ground explosively, extending your hips and knees. As the bar reaches your mid-thighs, shrug your shoulders and pull the bar up towards your chest, then drop underneath it to catch it at shoulder height.
      
      3.Use proper weights: Start with a weight that you can comfortably lift with good form. Gradually increase the weight as you become more comfortable with the movement.
      
      4.Keep your core tight: Engage your core muscles throughout the exercise to help stabilize your spine.
      
      5.Avoid hyperextension: Don't overextend your back or jerk the barbell too quickly, as this can lead to injury.
      
      6.Focus on technique: Practice the movement slowly and deliberately, focusing on proper technique and form. Only increase speed once you are comfortable with the movement.
      
      7.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during power cleans and ensure that you're getting the most out of your workout.''',
          '''Power clean to skomplikowane ćwiczenie, które wymaga właściwej techniki i formy, aby uniknąć kontuzji. To ruch wielostawowy, polegający na podnoszeniu sztangi z ziemi na wysokość ramion, wykorzystujący kombinację siły, szybkości i koordynacji.

Oto kilka wskazówek, które pomogą uniknąć kontuzji podczas wykonywania power clean:

1. Rozgrzewka: Spędź 10-15 minut na dynamicznych rozciąganiach i ćwiczeniach mobilności, aby przygotować ciało do ruchu.

2. Użyj właściwej techniki: Rozpocznij ćwiczenie z nogami na szerokość bioder, trzymając plecy prosto i lekko ugięte kolana. Użyj chwytu nadgarstkowego na sztandze i podnieś ją z ziemi dynamicznie, wyprostowując biodra i kolana. Kiedy sztanga osiągnie środek ud, unieś ramiona do góry i złap ją na wysokości ramion.

3. Używaj odpowiednich obciążeń: Zacznij od wagi, którą możesz wygodnie podnieść zachowując dobrą technikę. Stopniowo zwiększaj obciążenie, gdy będziesz bardziej komfortowy z ruchem.

4. Trzymaj napięte mięśnie brzucha: Aktywuj mięśnie brzucha przez całe ćwiczenie, aby pomóc w stabilizacji kręgosłupa.

5. Unikaj nadmiernego wygięcia: Nie wyginaj nadmiernie pleców ani gwałtownie nie szarpuj sztangi, ponieważ może to prowadzić do kontuzji.

6. Skup się na technice: Ćwicz ruch powoli i z rozmysłem, skupiając się na poprawnej technice i formie. Zwiększaj tempo dopiero po opanowaniu ruchu.

7. Słuchaj swojego ciała: Jeśli odczuwasz ból lub dyskomfort, natychmiast zatrzymaj ćwiczenie. Nie forsuj się przez ból, ponieważ to może prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas power clean i upewnić się, że osiągasz jak najlepsze rezultaty w trakcie treningu.'''),
      3,
      12),
  Exercise(
      '24',
      'Concentration\nCurl',
      "Biceps w\noparciu",
      "Biceps",
      "Biceps",
      true,
      "images/ConcentrationCurl.jpg",
      CreatingExercisePage(
          24,
          "images/Bicek.png",
          '''The concentration curl is a popular exercise that targets the biceps muscles. It involves sitting on a bench with one arm resting on the inside of your thigh, while the other arm lifts a dumbbell towards your shoulder.
      
      Here are some tips to help you avoid injury during concentration curls:
      
      1.Warm up properly: Spend 10-15 minutes doing dynamic stretches and mobility exercises to prepare your biceps for the movement.
      
      2.Use proper form: Sit on a bench with your back straight and your feet flat on the floor. Rest one arm on the inside of your thigh, and hold a dumbbell in the other hand. Slowly curl the dumbbell towards your shoulder, keeping your elbow stationary. Lower the dumbbell back down to the starting position, and repeat for the desired number of reps.
      
      3.Use proper weights: Choose a weight that you can comfortably lift with good form. Gradually increase the weight as you become more comfortable with the movement.
      
      4.Keep your core tight: Engage your core muscles throughout the exercise to help stabilize your spine.
      
      5.Avoid swinging or using momentum: Focus on using your bicep muscles to lift the weight, rather than swinging or using momentum.
      
      6.Avoid hyperextension: Don't overextend your elbow or wrist, as this can lead to injury.
      
      7.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during concentration curls and ensure that you're getting the most out of your workout.''',
          '''Concentration curl to popularne ćwiczenie, które skupia się na mięśniach bicepsów. Polega na siedzeniu na ławce z jednym ramieniem opartym na wewnętrznej stronie uda, podczas gdy drugie ramię unosi hantel w kierunku barku.

Oto kilka wskazówek, które pomogą uniknąć kontuzji podczas wykonywania concentration curls:

1. Rozgrzewka: Poświęć 10-15 minut na dynamiczne rozciąganie i ćwiczenia mobilności, aby przygotować swoje bicepsy do ruchu.

2. Użyj właściwej techniki: Usiądź na ławce z prostymi plecami i stopami na podłodze. Opierając jedno ramię na wewnętrznej stronie uda, trzymaj hantel w drugiej ręce. Powoli unosź hantel w kierunku barku, zachowując nieruchowy łokieć. Opuszczaj hantel z powrotem do pozycji wyjściowej i powtarzaj przez określoną liczbę powtórzeń.

3. Używaj odpowiednich obciążeń: Wybierz wagę, którą możesz wygodnie podnieść zachowując dobrą technikę. Stopniowo zwiększaj obciążenie w miarę jak stajesz się bardziej komfortowy z ruchem.

4. Trzymaj napięte mięśnie brzucha: Aktywuj mięśnie brzucha przez całe ćwiczenie, aby pomóc w stabilizacji kręgosłupa.

5. Unikaj huśtania lub korzystania z impetu: Skup się na wykorzystaniu mięśni bicepsów do podnoszenia wagi, zamiast machania ciałem lub korzystania z impetu.

6. Unikaj nadmiernego wygięcia: Nie nadmiernie wyginaj łokcia ani nadgarstka, ponieważ może to prowadzić do kontuzji.

7. Słuchaj swojego ciała: Jeśli odczuwasz ból lub dyskomfort, natychmiast zatrzymaj ćwiczenie. Nie forsuj się przez ból, ponieważ to może prowadzić do poważnych kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas concentration curls i upewnić się, że osiągasz jak najlepsze rezultaty w trakcie treningu.'''),
      2,
      10),
  Exercise(
      '25',
      'Cruch',
      "Brzuszki",
      "Abdominals",
      "Brzuch",
      false,
      "images/Cruch.jpg",
      CreatingExercisePage(
          25,
          "images/Brzuchy.png",
          '''Crunches are a popular abHomeinal exercise that involve flexing the spine and contracting the abHomeinal muscles. Here are some tips to help you avoid injuries while doing crunches:
      
      1.Warm up properly: Spend 10-15 minutes doing dynamic stretches and mobility exercises to prepare your core for the movement.
      
      2.Use proper form: Lie on your back with your knees bent and your feet flat on the floor. Place your hands behind your head or across your chest, and slowly lift your shoulders off the ground, curling your upper body towards your knees. Hold for a second, then lower back down to the starting position.
      
      3.Don't use your neck: Avoid pulling on your neck with your hands, as this can cause strain and injury. Instead, focus on using your abHomeinal muscles to lift your upper body.
      
      4.Avoid rapid movements: Don't use momentum or swing your body to perform the movement, as this can lead to injury.
      
      5.Don't overdo it: Avoid doing too many repetitions or sets, especially if you're new to the exercise. Start with a small number of reps and gradually increase over time.
      
      6.Avoid rounding your spine: Keep your lower back pressed into the ground throughout the exercise, and avoid rounding your spine.
      
      7.Breathe properly: Inhale as you lower your upper body back down to the ground, and exhale as you lift your shoulders off the ground.
      
      8.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during crunches and ensure that you're getting the most out of your workout.''',
          '''Crunches are a popular abHomeinal exercise that involve flexing the spine and contracting the abHomeinal muscles. Here are some tips to help you avoid injuries while doing crunches:
      
      1.Warm up properly: Spend 10-15 minutes doing dynamic stretches and mobility exercises to prepare your core for the movement.
      
      2.Use proper form: Lie on your back with your knees bent and your feet flat on the floor. Place your hands behind your head or across your chest, and slowly lift your shoulders off the ground, curling your upper body towards your knees. Hold for a second, then lower back down to the starting position.
      
      3.Don't use your neck: Avoid pulling on your neck with your hands, as this can cause strain and injury. Instead, focus on using your abHomeinal muscles to lift your upper body.
      
      4.Avoid rapid movements: Don't use momentum or swing your body to perform the movement, as this can lead to injury.
      
      5.Don't overdo it: Avoid doing too many repetitions or sets, especially if you're new to the exercise. Start with a small number of reps and gradually increase over time.
      
      6.Avoid rounding your spine: Keep your lower back pressed into the ground throughout the exercise, and avoid rounding your spine.
      
      7.Breathe properly: Inhale as you lower your upper body back down to the ground, and exhale as you lift your shoulders off the ground.
      
      8.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during crunches and ensure that you're getting the most out of your workout.'''),
      2,
      18),
  Exercise(
      '26',
      'Bicycle Crunch',
      "Rowerek",
      "Abdominals , Obliques",
      "Skośne i proste brzucha",
      false,
      "images/BicycleCrunch.jpg",
      CreatingExercisePage(
          26,
          "images/bicycle-crunch.png",
          '''Bicycle crunches are a great exercise for strengthening the abHomeinal muscles and obliques. However, it's important to use proper form and technique to avoid injury. Here are some tips to help you avoid injuries while doing bicycle crunches:
      
      1.Warm up properly: Spend 10-15 minutes doing dynamic stretches and mobility exercises to prepare your core for the movement.
      
      2.Use proper form: Lie on your back with your knees bent and your hands behind your head. Lift your shoulders off the ground and bring your left elbow towards your right knee, straightening your left leg. Then switch sides, bringing your right elbow towards your left knee, straightening your right leg. Continue alternating sides.
      
      3.Don't pull on your neck: Avoid pulling on your neck with your hands, as this can cause strain and injury. Instead, focus on using your abHomeinal muscles to lift your upper body.
      
      4.Keep your lower back pressed into the ground: Avoid arching your lower back or lifting your hips off the ground.
      
      5.Don't overdo it: Start with a small number of reps and gradually increase over time. Avoid doing too many repetitions or sets, especially if you're new to the exercise.
      
      6.Breathe properly: Inhale as you twist your torso and exhale as you straighten your legs.
      
      7.Listen to your body: If you feel any pain or discomfort, stop the exercise immediately. Don't push through the pain, as this can lead to serious injury.
      
      By following these tips, you can help prevent injuries during bicycle crunches and ensure that you're getting the most out of your workout.''',
          '''Rowery brzuszkowe to doskonałe ćwiczenie wzmacniające mięśnie brzucha i mięśnie skośne. Jednak ważne jest, aby stosować właściwą technikę i formę, aby uniknąć kontuzji. Oto kilka wskazówek, które pomogą Ci uniknąć kontuzji podczas wykonywania rowerów brzuszkowych:

Rozgrzewka: Poświęć 10-15 minut na dynamiczne rozciąganie i ćwiczenia mobilności, aby przygotować swoje mięśnie brzucha na ruch.

Użyj właściwej techniki: Połóż się na plecach z kolanami wygiętymi i rękoma za głową. Podnieś ramiona nad ziemię i przyciągnij lewy łokieć w kierunku prawego kolana, prostując lewą nogę. Następnie zmień stronę, przyciągając prawy łokieć w kierunku lewego kolana i prostując prawą nogę. Kontynuuj naprzemiennie.

Nie ciągnij za szyję: Unikaj pociągania za szyję rękami, ponieważ może to prowadzić do nadmiernego napięcia i kontuzji. Skoncentruj się na wykorzystywaniu mięśni brzucha do podnoszenia górnej części ciała.

Trzymaj dolną część pleców przyciśniętą do podłogi: Unikaj wyginania dolnej części pleców lub podnoszenia bioder nad ziemię.

Nie przesadzaj: Zacznij od niewielkiej liczby powtórzeń i stopniowo zwiększaj ją w miarę upływu czasu. Unikaj wykonywania zbyt wielu powtórzeń lub serii, zwłaszcza jeśli jesteś początkujący.

Prawidłowe oddychanie: Wdychaj powietrze podczas skręcania tułowia i wydychaj je podczas wyprostowania nóg.

Słuchaj swojego ciała: Jeśli odczuwasz ból lub dyskomfort, natychmiast przestań ćwiczyć. Nie forsuj się przez ból, ponieważ może to prowadzić do poważnej kontuzji.

Przestrzegając tych wskazówek, możesz pomóc uniknąć kontuzji podczas wykonywania rowerów brzuszkowych i upewnić się, że osiągasz jak najlepsze rezultaty podczas treningu.'''),
      3,
      20),
  Exercise(
      '27',
      'Decline\nBench Press',
      "Wyciskanie\nna skosie ujemnym",
      "Chest ,  Triceps",
      "Klatka piersiowa, Triceps",
      true,
      "images/DeclineBenchPresss.png",
      CreatingExercisePage(
          27,
          "images/declineBenchPress.png",
          '''Decline bench press is an effective exercise for targeting the lower portion of the chest muscles. However, performing it with incorrect form or excessive weight can lead to injuries. Here are some tips to avoid injuries while doing decline bench press:
      
      Warm-up: Before starting any exercise, it is essential to warm-up the body. A proper warm-up can help increase blood flow to the muscles and reduce the risk of injury.
      
      Use a spotter: Decline bench press can be dangerous if you fail to lift the weight or lose your balance. Always have a spotter to assist you during the exercise.
      
      Maintain proper form: Ensure you maintain proper form throughout the exercise. Keep your feet flat on the floor, elbows tucked in, and maintain a slight arch in your lower back. Avoid flaring your elbows out or lifting your head and shoulders off the bench.
      
      Use a proper grip: A proper grip can help you maintain control of the weight and avoid wrist injuries. Use a grip width that is comfortable for you and keep your wrists straight.
      
      Gradually increase weight: Start with a weight that you can comfortably lift and gradually increase the weight over time. Avoid lifting excessive weight that is beyond your strength level, as this can cause injuries.
      
      Avoid bouncing the weight: Bouncing the weight off your chest can lead to shoulder injuries. Always lower the weight under control, pause for a second, and then lift it back up.
      
      By following these tips, you can minimize the risk of injuries while doing decline bench press and get the most out of your workout.''',
          '''"Wyciskanie na skosie ujemnym na ławce to znakomite ćwiczenie, które celuje w dolną część mięśni klatki piersiowej. Jednakże, wykonując je z nieprawidłową techniką lub z nadmiernym obciążeniem, możesz narażać się na kontuzje. Oto kilka wskazówek, które pomogą Ci uniknąć urazów podczas wykonywania żyrandola na ławce:

1. Rozgrzewka: Zanim rozpoczniesz jakiekolwiek ćwiczenie, niezwykle ważne jest odpowiednie rozgrzanie organizmu. Poprawna rozgrzewka może pomóc zwiększyć przepływ krwi do mięśni i zmniejszyć ryzyko urazów.

2. Używaj asystenta: Wykonywanie żyrandola na ławce może być niebezpieczne, jeśli nie jesteś w stanie unieść obciążenia lub stracisz równowagę. Zawsze miej przy sobie osobę asystującą, która pomoże Ci podczas ćwiczenia.

3. Zachowaj prawidłową technikę: Upewnij się, że zachowujesz poprawną technikę przez całe ćwiczenie. Trzymaj nogi płasko na podłodze, łokcie zbliżone do tułowia i utrzymuj lekki łuk w dolnej części pleców. Unikaj rozsuwania łokci na boki oraz unikaj unoszenia głowy i ramion z ławki.

4. Użyj właściwego chwytu: Prawidłowy chwyt może pomóc Ci zachować kontrolę nad obciążeniem i uniknąć kontuzji nadgarstków. Wybierz szerokość chwytu, która jest dla Ciebie wygodna i utrzymuj nadgarstki prosto.

5. Stopniowo zwiększaj obciążenie: Rozpocznij od wagi, którą jesteś w stanie wygodnie unieść, a następnie stopniowo zwiększaj obciążenie w miarę upływu czasu. Unikaj unoszenia nadmiernego obciążenia, które przekracza Twoją siłę, ponieważ może to prowadzić do kontuzji.

6. Unikaj odbijania obciążenia: Odbijanie obciążenia od klatki piersiowej może prowadzić do kontuzji barków. Zawsze opuszczaj obciążenie pod kontrolą, zatrzymaj na chwilę na klatce piersiowej, a następnie unieś je z powrotem.

Przestrzegając tych wskazówek, minimalizujesz ryzyko kontuzji podczas wykonywania żyrandola na ławce i w pełni wykorzystujesz swój trening."'''),
      2,
      12),
  Exercise(
      '28',
      'Muscle up',
      "Muscle up",
      'Lats, Triceps',
      "Plecy, triceps",
      true,
      "images/muscleUp.jpeg",
      CreatingExercisePage(
          28,
          "images/usedMusclesMuscleUp.png",
          '''Muscle up is an advanced bodyweight exercise that combines a pull-up and a dip into one fluid motion. It primarily targets the upper body muscles, especially the back, chest, and arms. Here are some tips to perform muscle ups effectively and safely:

1. Develop Upper Body Strength: Muscle ups require considerable upper body strength. Prioritize exercises like pull-ups, dips, and muscle up progressions to build the necessary strength.

2. Master the Technique: Learn the proper technique for both the pull-up and the dip. Practice the transition between the two movements to perform a seamless muscle up.

3. Use False Grip: Adopt a false grip, where your palms are positioned above the bar with your thumb alongside your fingers. This grip facilitates the transition from pull-up to dip.

4. Engage Core Muscles: Maintain a tight core throughout the movement to provide stability and control.

5. Start with Assistance: Begin by using resistance bands or a spotter to assist you until you build enough strength to perform an unassisted muscle up.

6. Avoid Kipping: While kipping can help generate momentum, it's crucial to prioritize strict form to fully engage the targeted muscles and reduce the risk of injury.

7. Gradually Increase Volume: Once you've mastered the technique, gradually increase the number of repetitions to further develop your strength and endurance.

By following these tips and practicing consistently, you can master the muscle up while minimizing the risk of injury and maximizing its effectiveness in your workout routine.''',
          '''Muscle up to zaawansowane ćwiczenie wykonywane przy użyciu ciężaru własnego ciała, które łączy w sobie podciąganie i pompki w płynnym ruchu. Głównie angażuje mięśnie górnej partii ciała, szczególnie plecy, klatkę piersiową i ramiona. Oto kilka wskazówek, jak wykonywać muscle up efektywnie i bezpiecznie:

1. Rozwijaj siłę górnej części ciała: Do wykonania muscle up potrzebna jest znaczna siła górnej części ciała. Skup się na ćwiczeniach takich jak podciągania, pompki i progresje muscle up, aby zbudować niezbędną siłę.

2. Opanuj technikę: Naucz się prawidłowej techniki zarówno podczas podciągania, jak i pompki. Ćwicz przejście między tymi dwoma ruchami, aby wykonywać płynne muscle up.

3. Używaj fałszywego chwytu (false grip): Przyjmij fałszywy chwyt, gdzie dłonie są umieszczone nad drążkiem z kciukiem wzdłuż palców. Taki chwyt ułatwia przejście z podciągania do pompki.

4. Aktywuj mięśnie brzucha: Utrzymuj napięcie w mięśniach brzucha podczas całego ruchu, aby zapewnić stabilność i kontrolę.

5. Zacznij z pomocą: Rozpocznij używając gum oporowych lub osoby pomagającej, dopóki nie zbudujesz wystarczającej siły do wykonania samodzielnie muscle up.

6. Unikaj machania (kipowania): Choć machanie może generować impet, ważne jest, aby skupić się na ścisłej formie, aby w pełni zaangażować docelowe mięśnie i zmniejszyć ryzyko urazu.

7. Stopniowo zwiększaj liczbę powtórzeń: Po opanowaniu techniki stopniowo zwiększaj liczbę powtórzeń, aby dalej rozwijać swoją siłę i wytrzymałość.

Śledząc te wskazówki i regularnie ćwicząc, możesz opanować muscle up, minimalizując ryzyko kontuzji i maksymalizując jego skuteczność w Twoim treningu.'''),
      2,
      4),
  Exercise(
      '29',
      'Push up',
      "Pompki",
      "Chest, Triceps",
      "Klatka piersiowa, triceps",
      false,
      "images/pushUp.webp",
      CreatingExercisePage(
          29,
          "images/usedMusclesPushUp.png",
          '''Push-ups are a fundamental bodyweight exercise that target multiple muscle groups, primarily the chest, shoulders, and triceps. Here are some tips to perform push-ups effectively and safely:

1. Maintain Proper Form: Keep your body in a straight line from head to heels. Engage your core muscles and avoid sagging or arching your back.

2. Hand Placement: Position your hands slightly wider than shoulder-width apart. Experiment with different hand placements to target specific muscle groups.

3. Elbow Position: Keep your elbows close to your body at a 45-degree angle to your torso. Avoid flaring your elbows outward.

4. Range of Motion: Lower your body until your chest nearly touches the ground. Ensure a full range of motion without compromising form.

5. Breathing: Inhale as you lower your body and exhale as you push back up.

6. Gradually Increase Intensity: Start with a manageable number of repetitions and gradually increase as your strength improves.

7. Variations: Explore variations like diamond push-ups, incline or decline push-ups to challenge different muscle groups.

8. Rest and Recovery: Allow your muscles to rest between sessions to prevent overtraining and promote muscle recovery.

By incorporating these tips and maintaining consistency in your push-up routine, you can effectively strengthen your upper body while reducing the risk of injury.''',
          '''Pompki są fundamentalnym ćwiczeniem wykonywanym przy użyciu ciężaru własnego ciała, które angażuje wiele grup mięśniowych, głównie klatkę piersiową, barki i tricepsy. Oto kilka wskazówek, jak wykonywać pompki efektywnie i bezpiecznie:

1. Zachowaj Prawidłową Technikę: Utrzymuj ciało w prostej linii od głowy do pięt. Napięj mięśnie brzucha i unikaj wyginania lub garbienia się w odcinku lędźwiowym.

2. Pozycja Rąk: Umieść dłonie nieco szerzej niż na szerokość barków. Eksperymentuj z różnymi ułożeniami rąk, aby celować w konkretne grupy mięśniowe.

3. Pozycja Łokci: Trzymaj łokcie blisko ciała pod kątem 45 stopni do tułowia. Unikaj rozsuwania łokci na boki.

4. Zakres Ruchu: Opuszczaj ciało aż do momentu, gdy klatka piersiowa niemal dotyka podłoża. Zapewnij pełny zakres ruchu bez kompromitowania techniki.

5. Oddychanie: Wdychaj podczas opuszczania ciała i wydychaj podczas wypychania się do góry.

6. Stopniowo Zwiększ Intensywność: Rozpocznij od sensownej liczby powtórzeń i stopniowo zwiększaj, w miarę jak wzrasta Twoja siła.

7. Warianty: Spróbuj różnych wariantów, takich jak pompki diamentowe, pompki na podwyższeniu lub pompki ze spadkiem, aby zmierzyć się z różnymi grupami mięśniowymi.

8. Odpoczynek i Regeneracja: Pozwól mięśniom odpocząć między treningami, aby zapobiec przetrenowaniu i wspomóc proces regeneracji mięśniowej.

Poprzez uwzględnienie tych wskazówek i regularne wykonywanie pompki, możesz skutecznie wzmacniać górną partię ciała, jednocześnie zmniejszając ryzyko kontuzji.'''),
      3,
      20),
  Exercise(
      '30',
      'Plank',
      "Deska",
      "Abdominals",
      "Brzuch",
      false,
      "images/plank.webp",
      CreatingExercisePage(
          30,
          "images/usedMusclesPlank.png",
          '''The plank is a core-strengthening exercise that engages multiple muscle groups, including the abdominals, back, and shoulders. Here are some tips to perform the plank effectively and safely:

1. Proper Alignment: Maintain a straight line from your head to your heels. Engage your core muscles and avoid sagging or raising your hips too high.

2. Elbow and Hand Placement: Place your elbows directly beneath your shoulders or clasp your hands together. Experiment with variations to find a comfortable position.

3. Focus on Breathing: Breathe deeply and evenly while holding the plank position. Avoid holding your breath, as proper breathing enhances stability.

4. Time Under Tension: Start by holding the plank for a duration that challenges you without compromising form. Gradually increase the duration as your strength improves.

5. Engage Muscles: Squeeze your glutes and thighs while holding the plank to create tension throughout your body.

6. Variety in Plank Position: Explore different plank variations such as side planks or plank with leg lifts to target various muscle groups.

7. Quality Over Quantity: Focus on maintaining proper form rather than holding the plank for an extended period with compromised technique.

8. Rest and Recovery: Allow your muscles to rest between plank sessions to prevent overuse and aid in muscle recovery.

By incorporating these tips and consistently practicing the plank, you can effectively strengthen your core muscles while reducing the risk of injury.''',
          '''Deska jest ćwiczeniem wzmacniającym mięśnie brzucha, pleców i ramion. Oto kilka wskazówek, jak wykonywać deskę efektywnie i bezpiecznie:

1. Prawidłowe Ułożenie Ciała: Utrzymuj prostą linię od głowy do pięt. Aktywuj mięśnie brzucha i unikaj garbienia się lub podnoszenia bioder zbyt wysoko.

2. Pozycja Łokci i Rąk: Umieść łokcie bezpośrednio pod barkami lub złącz dłonie razem. Eksperymentuj z różnymi wariantami, aby znaleźć wygodną pozycję.

3. Skupienie na Oddychaniu: Oddychaj głęboko i równomiernie podczas utrzymywania pozycji deski. Unikaj wstrzymywania oddechu, ponieważ prawidłowe oddychanie zwiększa stabilność.

4. Czas w Napięciu: Zacznij od trzymania deski przez określony czas, który stanowi wyzwanie, nie narażając techniki. Stopniowo zwiększaj czas, gdy wzrasta Twoja siła.

5. Aktywacja Mięśni: Napnij pośladki i uda podczas trzymania deski, aby stworzyć napięcie w całym ciele.

6. Różnorodność w Pozycji Deski: Wypróbuj różne warianty deski, takie jak deska boczna czy deska z unoszeniem nóg, aby celować w różne grupy mięśniowe.

7. Jakość Przed Ilością: Skup się na zachowaniu prawidłowej techniki zamiast trzymania deski przez długi czas z kompromitującą techniką.

8. Odpoczynek i Regeneracja: Pozwól mięśniom odpocząć między seriami deski, aby zapobiec przetrenowaniu i wspomóc regenerację mięśniową.

Poprzez uwzględnienie tych wskazówek i regularne praktykowanie deski, możesz efektywnie wzmacniać mięśnie brzucha, jednocześnie zmniejszając ryzyko kontuzji.'''),
      2,
      45),
  Exercise(
      '31',
      'Single arm lat pull down',
      "Ściąganie wyciagu\ngórnego jednorącz",
      "Lats",
      "Plecy",
      false,
      "images/singleArmLatPullDown.jpeg",
      CreatingExercisePage(
          31,
          "images/usedMuscleSingleArmLatPullDown.png",
          '''The single-arm lat pull-down is an effective exercise targeting the latissimus dorsi, engaging the back muscles and aiding in overall upper body strength. Here are some tips to perform the single-arm lat pull-down effectively and safely:

1. Adjust the Machine: Set the cable pulley to an appropriate height, ensuring it's above your head. Adjust the weight to a manageable level.

2. Proper Positioning: Stand facing the cable machine with your feet shoulder-width apart. Grab the handle with an underhand grip and step back to create tension in the cable.

3. Engage Core Muscles: Keep your core muscles engaged throughout the movement to stabilize your body and avoid swaying.

4. Initiate the Pull: Start the movement by pulling the handle downwards towards your side while keeping your elbow close to your body. Focus on engaging your lat muscles.

5. Control the Movement: Slowly release the handle back to the starting position without allowing the weight stack to slam.

6. Maintain Posture: Ensure your back remains straight, and avoid leaning back excessively during the pull-down.

7. Alternate Sides: Perform the same number of repetitions on both arms to maintain balance and symmetry in muscle development.

8. Gradually Increase Weight: Begin with a lighter weight to master the technique, then gradually increase the resistance as your strength improves.

By following these tips and maintaining proper form, you can effectively target your lats and enhance your overall upper body strength with the single-arm lat pull-down.''',
          '''Ściąganie wyciągu górnego jednorącz to skuteczne ćwiczenie, które angażuje mięśnie szerokich pleców, wzmacniając mięśnie pleców i przyczyniając się do ogólnej siły górnej partii ciała. Oto kilka wskazówek, jak wykonywać ćwiczenie ściąganie wyciągu górnego jednorącz efektywnie i bezpiecznie:

1. Dostosuj Maszynę: Ustaw pulpit wyciągu na odpowiedniej wysokości, zapewniając, że znajduje się nad Twoją głową. Dostosuj obciążenie do poziomu, który jest dla Ciebie wygodny.

2. Prawidłowa Pozycja: Stań twarzą do maszyny wyciągu z nogami rozstawionymi na szerokość barków. Chwytaj uchwyt podchwytem i cofnij się, aby stworzyć napięcie w kablu.

3. Aktywuj Mięśnie Brzucha: Utrzymuj napięcie mięśni brzucha przez cały ruch, aby stabilizować ciało i uniknąć kołysania.

4. Rozpocznij Ruch: Zacznij ruch, ciągnąc uchwyt w dół ku swojej stronie, jednocześnie trzymając łokieć blisko ciała. Skup się na zaangażowaniu mięśni szerokich pleców.

5. Kontroluj Ruch: Powoli wypuść uchwyt z powrotem do pozycji wyjściowej, nie pozwalając na gwałtowne opadnięcie obciążenia.

6. Utrzymuj Postawę: Upewnij się, że plecy pozostają proste i unikaj nadmiernego odchylania się do tyłu podczas ściągania wyciągu.

7. Zmień Stronę: Wykonuj tę samą liczbę powtórzeń na obu rękach, aby utrzymać równowagę i symetrię w rozwoju mięśni.

8. Stopniowo Zwiększaj Obciążenie: Zacznij od mniejszego obciążenia, aby opanować technikę, a następnie stopniowo zwiększaj opór w miarę poprawy siły.

Śledząc te wskazówki i utrzymując prawidłową technikę, możesz skutecznie skoncentrować się na mięśniach szerokich pleców i poprawić ogólną siłę górnej partii ciała dzięki ćwiczeniu ściąganie wyciągu górnego jednorącz.'''),
      2,
      30),
  Exercise(
      '32',
      'Scapular pull up',
      "Spięcia łopatek",
      "Lats",
      "Plecy",
      true,
      "images/scapularPullUp.jpeg",
      CreatingExercisePage(
          32,
          "images/UsedMusclesScapularPushUp.png",
          '''Scapular pull-ups are an excellent exercise for targeting the muscles surrounding the scapulae, aiding in improving scapular stability and upper body strength. Here are some tips to perform scapular pull-ups effectively:

1. Hanging Position: Hang from a pull-up bar with an overhand grip, allowing your arms to fully extend.

2. Scapular Retraction: Initiate the movement by retracting your shoulder blades without bending your arms. Focus on pulling your shoulder blades down and back.

3. Control the Movement: Avoid using momentum or swinging during the exercise. Focus on a controlled movement solely involving the scapulae.

4. Hold and Release: Hold the retracted position for a moment at the top, then slowly release back to the starting position.

5. Breathing: Breathe naturally throughout the movement, inhaling as you retract your shoulder blades and exhaling as you release.

6. Gradual Progression: Start with a few repetitions and gradually increase as you become more comfortable with the movement.

7. Focus on Form: Prioritize proper scapular movement and engagement over the number of repetitions.

By incorporating these tips into your scapular pull-up routine, you can effectively strengthen the muscles around the scapulae, aiding in better posture and shoulder stability.''',
          '''Spięcia łopatek są doskonałym ćwiczeniem, które celuje w mięśnie otaczające łopatki, pomagając w poprawie stabilności łopatkowej i siły górnej partii ciała. Oto kilka wskazówek, jak wykonywać spięcia łopatek skutecznie:

1. Pozycja Wiszenia: Wisząc na drążku do podciągania, złap się nachwytem, pozwalając, aby Twoje ramiona były w pełni wyprostowane.

2. Retrakcja Łopatek: Rozpocznij ruch poprzez cofnięcie łopatek bez zginania ramion. Skup się na przyciąganiu łopatek w dół i do tyłu.

3. Kontroluj Ruch: Unikaj używania impetu lub kołysania się podczas ćwiczenia. Skup się na kontrolowanym ruchu, który angażuje wyłącznie łopatki.

4. Wytrzymaj i Zwolnij: Wytrzymaj w pozycji spiętych łopatek przez chwilę na górze, a następnie powoli wróć do pozycji wyjściowej.

5. Oddychanie: Oddychaj naturalnie przez cały ruch, wdychając podczas cofania łopatek i wydychając podczas powrotu.

6. Stopniowa Progresja: Zacznij od kilku powtórzeń i stopniowo zwiększaj ich liczbę w miarę jak nabierzesz pewności w wykonywaniu ćwiczenia.

7. Skupienie na Technice: Priorytetem jest poprawny ruch i zaangażowanie łopatek, a nie liczba powtórzeń.

Poprzez włączenie tych wskazówek do swojego treningu spięć łopatek, możesz efektywnie wzmacniać mięśnie wokół łopatek, co przyczyni się do lepszej postawy i stabilności ramion.'''),
      2,
      20),
  Exercise(
      '33',
      'Shrugs',
      "Szrugsy",
      "Traps",
      "Kaptury",
      true,
      "images/shrugs.png",
      CreatingExercisePage(
          33,
          "images/usedMusclesShrusgs.png",
          '''Shrugs are a beneficial exercise primarily targeting the trapezius muscles, aiding in upper back and shoulder strength. Here are some tips to perform shrugs effectively:

1. Starting Position: Stand upright with your feet shoulder-width apart, holding a pair of dumbbells or a barbell in front of your thighs.

2. Shoulder Movement: Elevate your shoulders toward your ears as high as possible while keeping your arms straight. Focus on the upward motion using the muscles around your neck and upper back.

3. Squeeze and Hold: Hold the top position for a moment to maximize muscle contraction in the trapezius muscles.

4. Control the Descent: Slowly lower your shoulders back to the starting position, resisting the urge to drop them quickly.

5. Breathing: Inhale before lifting your shoulders and exhale as you release back down.

6. Gradual Progression: Begin with a manageable weight and gradually increase as your strength improves.

7. Mind-Muscle Connection: Focus on engaging the trapezius muscles throughout the movement.

8. Proper Posture: Maintain proper posture by keeping your back straight and avoiding leaning forward or backward.

Incorporating these tips into your shrugs routine will help you effectively target and strengthen your trapezius muscles.''',
          '''Szrugsy są korzystnym ćwiczeniem, głównie skupiającym się na mięśniach czworobocznych, wzmacniającymi górną część pleców oraz barki. Oto kilka wskazówek, jak wykonywać szrugsy efektywnie:

1. Pozycja Wyjściowa: Stań prosto, stopy rozstawione na szerokość barków, trzymając parę hantli lub sztangę przed udami.

2. Ruch Ramion: Podnieś ramiona jak najwyżej w stronę uszu, zachowując proste ramiona. Skup się na unoszeniu ramion za pomocą mięśni okolic szyi i górnej części pleców.

3. Ściśnij i Wytrzymaj: Wytrzymaj w górnej pozycji przez chwilę, aby maksymalnie napiąć mięśnie czworoboczne.

4. Kontrolowany Powrót: Powoli opuść ramiona do pozycji wyjściowej, opierając się pokusie gwałtownego opadania.

5. Oddychanie: Wdychaj przed podniesieniem ramion i wydychaj podczas powrotu.

6. Stopniowa Progresja: Zacznij od sensownego obciążenia i stopniowo zwiększaj je w miarę jak wzrasta Twoja siła.

7. Koncentracja na Mięśniach: Skup się na zaangażowaniu mięśni czworobocznych przez cały ruch.

8. Prawidłowa Postawa: Utrzymuj prawidłową postawę, trzymając plecy prosto i unikając przechylania się do przodu lub do tyłu.

Włączenie tych wskazówek do treningu szrugsów pomoże Ci skutecznie celować i wzmacniać mięśnie czworoboczne.'''),
      2,
      12),
  Exercise(
      '34',
      'Side plank',
      "Plank bokiem",
      "Abdominals , Obliques",
      "Skośne i prosty brzucha",
      false,
      "images/sidePlank.jpeg",
      CreatingExercisePage(
          34,
          "images/usedMusclesSidePlank.png",
          '''The side plank is a fantastic exercise for targeting the obliques and improving core strength. Here are some tips to perform side planks effectively:

1. Starting Position: Lie on your side with your legs extended and stack your feet on top of each other or stagger them for better balance.

2. Elbow Placement: Prop your body up on your elbow directly beneath your shoulder.

3. Lift Hips: Raise your hips off the ground, creating a straight line from your head to your feet. Engage your core muscles to maintain stability.

4. Hold and Squeeze: Hold the position while squeezing your oblique muscles. Focus on keeping your body straight without sagging or twisting.

5. Breathing: Breathe deeply and continuously throughout the exercise, avoiding holding your breath.

6. Gradual Progression: Start with a shorter duration and gradually increase the time as your core strength improves.

7. Both Sides: Perform the side plank on both sides to work both sets of oblique muscles equally.

8. Proper Alignment: Ensure your body is in a straight line without leaning forward or backward.

By incorporating these tips into your side plank routine, you can effectively engage your oblique muscles and enhance your overall core strength.''',
          '''Plank bokiem to doskonałe ćwiczenie, które koncentruje się na mięśniach skośnych brzucha i poprawia siłę rdzenia. Oto kilka wskazówek, jak wykonywać plank bokiem efektywnie:

1. Pozycja Wyjściowa: Połóż się na boku, wyprostuj nogi i umieść jedną na drugiej lub ustaw je w przesunięciu dla lepszej równowagi.

2. Pozycja Łokcia: Wspieraj się na łokciu bezpośrednio pod ramieniem.

3. Podnieś Biodra: Unieś biodra nad podłoże, tworząc prostą linię od głowy do stóp. Aktywuj mięśnie brzucha, aby utrzymać stabilność.

4. Wytrzymaj i Napnij: Wytrzymaj w pozycji, jednocześnie napinając mięśnie skośne brzucha. Skup się na utrzymaniu ciała prosto, bez garbienia się lub skręcania.

5. Oddychanie: Oddychaj głęboko i równomiernie podczas ćwiczenia, unikając wstrzymywania oddechu.

6. Stopniowa Progresja: Zacznij od krótszego czasu trzymania pozycji i stopniowo zwiększaj czas, w miarę jak wzrasta siła rdzenia.

7. Obie Strony: Wykonuj plank bokiem na obu stronach, aby równomiernie pracować obie grupy mięśni skośnych.

8. Prawidłowa Linia Ciała: Upewnij się, że Twoje ciało tworzy prostą linię, bez pochylania się do przodu lub do tyłu.

Poprzez uwzględnienie tych wskazówek w ćwiczeniu plank bokiem, skutecznie zaangażujesz mięśnie skośne brzucha i wzmocnisz swoją siłę rdzenia.'''),
      3,
      10),
  Exercise(
      '35',
      'Romainian deadlift',
      "Rumuńskie ciągi",
      "Glutes",
      "Pośladki",
      true,
      "images/romanianDeadlift.webp",
      CreatingExercisePage(
          35,
          "images/Romanian-Deadlift-Muscles-Worked-scaled.png",
          '''The Romanian deadlift is an effective exercise primarily targeting the hamstrings, glutes, and lower back. Here are some tips to perform Romanian deadlifts effectively:

1. Starting Position: Stand upright holding a barbell or dumbbells in front of your thighs, maintaining a shoulder-width stance.

2. Hinge at the Hips: Initiate the movement by pushing your hips backward while keeping your back straight. Lower the weight by bending at the hips, not the waist.

3. Maintain a Straight Back: Keep your spine neutral and your chest up throughout the movement. Avoid rounding your back.

4. Lower the Weight: Lower the barbell or dumbbells until you feel a stretch in your hamstrings. Ensure control and avoid going too low to maintain tension in the muscles.

5. Engage Hamstrings and Glutes: Focus on engaging your hamstrings and glutes to return to the starting position. Drive through your heels as you stand back up.

6. Control and Squeeze: As you stand tall, squeeze your glutes at the top position to maximize muscle activation.

7. Breathing: Inhale as you lower the weight and exhale as you return to the starting position.

8. Gradual Progression: Start with lighter weights to master the technique, then gradually increase the resistance as you become comfortable.

By following these tips, you can effectively target the posterior chain and improve strength with Romanian deadlifts.''',
          '''Rumuńskie ciągi to skuteczne ćwiczenie, które głównie koncentruje się na mięśniach łydek, pośladków oraz dolnej części pleców. Oto kilka wskazówek, jak wykonywać rumuńskie ciągi efektywnie:

1. Pozycja Wyjściowa: Stań prosto, trzymając sztangę lub hantle przed udami i zachowując postawę na szerokość ramion.

2. Zgięcie w Biodrach: Rozpocznij ruch przesuwając biodra do tyłu, zachowując przy tym prostą linię pleców. Opuszczaj ciężar, zginając się w biodrach, a nie w pasie.

3. Utrzymuj Prostą Plecy: Zachowaj neutralną krzywiznę kręgosłupa i unieś klatkę piersiową podczas ruchu. Unikaj zaokrąglania pleców.

4. Opuszczaj Ciężar: Opuszczaj sztangę lub hantle, aż poczujesz rozciągnięcie w mięśniach łydek. Kontroluj ruch i nie schodź zbyt nisko, aby utrzymać napięcie w mięśniach.

5. Zaangażuj Łydki i Pośladki: Skup się na zaangażowaniu mięśni łydek i pośladków, wracając do pozycji wyjściowej. Wypychaj przez pięty, gdy wracasz do pozycji stojącej.

6. Kontrola i Ściśnij: Gdy wstajesz, ściskaj pośladki na górze, aby maksymalnie aktywować mięśnie.

7. Oddychanie: Wdychaj, gdy opuszczasz ciężar, i wydychaj, wracając do pozycji wyjściowej.

8. Stopniowa Progresja: Zacznij od lżejszych obciążeń, aby opanować technikę, a następnie stopniowo zwiększaj opór, gdy nabierzesz pewności.

Śledząc te wskazówki, możesz skutecznie angażować mięśnie tylnego łańcucha i poprawić siłę dzięki rumuńskim ciągom.'''),
      3,
      10),
];

class FilteredPage extends StatelessWidget {
  final String text1;
  FilteredPage(
    this.text1,
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  Future<String> getLanguage() async {
    var language = "";
    CollectionReference collection = firestore.collection('${user.email}');
    QuerySnapshot querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      language = (data['language'].toString());
    }
    return language;
  }

  @override
  Widget build(BuildContext context) {
    final _results =
        _Exercises.where((exercise) => exercise.bodyPart.contains(text1))
            .toList();
    Future<String> Tytul(int index) async {
      String language = await getLanguage();
      if (language == "English") {
        return _results[index].title;
      } else {
        return _results[index].titlePL;
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('$text1 exercises',
        textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255))),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromARGB(240, 5, 5, 5),
                Color.fromARGB(230, 10, 10, 10),
              ],
              tileMode: TileMode.mirror),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                          context, _createRoute(_results[index].namePage)),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                        ),
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: 0.8,
                              child: Container(
                                  decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: AssetImage(
                                    _results[index].gifCode,
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              )),
                            ),
                            Container(
                                decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: <Color>[
                                  Color.fromARGB(175, 0, 0, 0),
                                  Color.fromARGB(125, 0, 0, 0),
                                  Color.fromARGB(15, 0, 0, 0),
                                ],
                              ),
                            )),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 15, 0, 0),
                                        //alignment: Alignment.centerRight,
                                        child: FutureBuilder(
                                            future: Tytul(index),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                }
                                                return Text(
                                                  snapshot.data ??
                                                      '', // Use the title or a default value
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: 'Satoshi',
                                                    color: Color.fromARGB(
                                                        180, 255, 255, 255),
                                                  ),
                                                );
                                              } else {
                                                return const CircularProgressIndicator(
                                                  color: Color.fromARGB(
                                                      180, 255, 255, 255),
                                                );
                                              }
                                            })),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _results.length,
                ),
                itemExtent: 155,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Widget Page2) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 1200),
  );
}
