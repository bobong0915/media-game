<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>傳媒功能配對遊戲</title>
    <style>
        body {
            font-family: 'Comic Sans MS', sans-serif;
            text-align: center;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4, #ffdde1, #fc6076);
            background-size: 400% 400%;
            animation: gradientBG 10s ease infinite;
            color: white;
        }

        @keyframes gradientBG {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        h1 {
            font-size: 42px;
            text-shadow: 3px 3px 6px #333;
        }

        .game-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .categories {
            display: flex;
            justify-content: space-around;
            margin-top: 30px;
            width: 80%;
            flex-wrap: wrap;
        }

        .category {
            width: 220px;
            min-height: 200px;
            border: 5px solid white;
            background-color: rgba(255, 255, 255, 0.9);
            text-align: center;
            padding: 20px;
            border-radius: 20px;
            font-size: 28px;
            font-weight: bold;
            transition: 0.3s;
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .category.correct {
            background-color: #4CAF50;
            color: white;
            box-shadow: 0 0 20px #4CAF50;
        }

        .category.wrong {
            background-color: #FF4C4C;
            color: white;
            box-shadow: 0 0 20px #FF4C4C;
        }

        .questions-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 20px;
        }

        .draggable {
            background-color: #ffcc00;
            padding: 15px;
            margin: 10px;
            border-radius: 15px;
            cursor: grab;
            font-size: 26px;
            font-weight: bold;
            color: black;
        }

        .draggable:hover {
            background-color: #ffd700;
            transform: scale(1.1);
        }

        #score {
            margin-top: 30px;
            font-size: 30px;
            font-weight: bold;
        }

        .popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.5);
            text-align: center;
            font-size: 40px;
            font-weight: bold;
            color: #4CAF50;
            animation: popupFadeIn 1s ease-in-out;
        }

        .popup img {
            width: 250px;
            height: auto;
            margin-top: 10px;
        }

        @keyframes popupFadeIn {
            from { opacity: 0; transform: translate(-50%, -60%); }
            to { opacity: 1; transform: translate(-50%, -50%); }
        }

        /* 氣球動畫 */
        @keyframes balloon {
            0% { transform: translateY(100vh) scale(0.5); opacity: 1; }
            100% { transform: translateY(-10vh) scale(1); opacity: 0; }
        }

        .balloon {
            position: absolute;
            width: 40px;
            height: 60px;
            background: red;
            border-radius: 50%;
            animation: balloon 4s ease-in-out infinite;
        }
    </style>
</head>
<body>

    <h1>🎮 傳媒功能配對遊戲 🎮</h1>
    <div class="game-container">
        <div class="questions-container" id="questions-container"></div>

        <div class="categories">
            <div class="category" id="news" ondragover="allowDrop(event)" ondrop="drop(event, 'news')">📰 時事</div>
            <div class="category" id="education" ondragover="allowDrop(event)" ondrop="drop(event, 'education')">📚 教育</div>
            <div class="category" id="entertainment" ondragover="allowDrop(event)" ondrop="drop(event, 'entertainment')">🎭 娛樂</div>
        </div>

        <div id="score">得分: 0</div>

        <div class="popup" id="popup">
            🎉 闖關成功！ 🎉
            <img src="https://i.imgur.com/2FLEUoE.jpeg" alt="闖關成功圖片">
        </div>
    </div>

    <script>
        const programs = [
            { name: "新聞報導", category: "news" },
            { name: "兒童百科", category: "education" },
            { name: "娛樂百分百", category: "entertainment" },
            { name: "每日新聞", category: "news" },
            { name: "科學小知識", category: "education" },
            { name: "音樂MV", category: "entertainment" },
            { name: "財經新聞", category: "news" },
            { name: "學習英語", category: "education" },
            { name: "搞笑綜藝節目", category: "entertainment" },
            { name: "全球時事", category: "news" }
        ];

        const container = document.getElementById("questions-container");

        programs.forEach((program, index) => {
            let div = document.createElement("div");
            div.classList.add("draggable");
            div.textContent = program.name;
            div.draggable = true;
            div.id = "drag-" + index;
            div.dataset.category = program.category;
            div.addEventListener("dragstart", drag);
            container.appendChild(div);
        });

        function allowDrop(event) {
            event.preventDefault();
        }

        function drag(event) {
            event.dataTransfer.setData("text", event.target.id);
        }

        function drop(event, category) {
            event.preventDefault();
            let draggedId = event.dataTransfer.getData("text");
            let draggedElement = document.getElementById(draggedId);
            let target = event.target;

            if (draggedElement.dataset.category === category) {
                target.appendChild(draggedElement);
                target.classList.add("correct");
                updateScore();
            } else {
                target.classList.add("wrong");
                setTimeout(() => target.classList.remove("wrong"), 500);
            }
        }

        let score = 0;
        function updateScore() {
            score += 10;
            document.getElementById("score").textContent = `得分: ${score}`;
            if (score === programs.length * 10) {
                document.getElementById("popup").style.display = "block";
                showBalloons();
            }
        }

        function showBalloons() {
            for (let i = 0; i < 10; i++) {
                let balloon = document.createElement("div");
                balloon.classList.add("balloon");
                balloon.style.left = `${Math.random() * 100}vw`;
                document.body.appendChild(balloon);
                setTimeout(() => balloon.remove(), 4000);
            }
        }
    </script>

</body>
</html>
