/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

import java.util.Map;
import java.util.Collections;

public
final HashMap<String, Tag> allTags = new HashMap<String, Tag>(); // Map of all tags/topics

/** Gets only answers which are related to question tags */
private
JSONObject _getAnswer(Question question, JSONArray answers) {
    final ArrayList<JSONObject> matchingAnswers = new ArrayList<JSONObject>();

    for (int index = 0; index < answers.size(); index++) {
        final JSONObject answer = answers.getJSONObject(index);

        for (Tag tag : question.tags) { // Check if tags match
            if (tag.name.matches(answer.getString("match"))) {
                matchingAnswers.add(answer);

                continue;
            }
        }
    }

    return matchingAnswers.size() == 0
        ? null
        : matchingAnswers.get(round(random(0, matchingAnswers.size() - 1)));
}

void setup() {
    final JSONObject data = loadJSONObject("./data.json"); // Data from the data.json file
    final String[] names = data.getJSONArray("names").getStringArray(); // List of names
    final JSONArray questions = data.getJSONArray("questions");         // List of questions
    final JSONArray answers = data.getJSONArray("answers");             // List of answers

    final String[] commentsPos = // Positive comments
        data.getJSONObject("comments").getJSONArray("positive").getStringArray();
    final String[] commentsNeg = // Negative and mean comments
        data.getJSONObject("comments").getJSONArray("negative").getStringArray();


    // Only grab random names once to avoid duplicate names
    final int nameIndex = round(random(0, names.length - 3));

    final User user1 = new User(names[nameIndex]);
    final User user2 = new User(names[nameIndex + 1]);
    final User user3 = new User(names[nameIndex + 2]);

    println(repeat("-", 75));
    println(user1);
    println(user2);
    println(user3);

    final JSONObject q1Data = questions.getJSONObject(round(random(0, questions.size() - 1)));
    final JSONObject q2Data = questions.getJSONObject(round(random(0, questions.size() - 1)));
    final JSONObject q3Data = questions.getJSONObject(round(random(0, questions.size() - 1)));
    Question currentQuestion;
    Answer currentAnswer;

    user1.askQuestion(
        q1Data.getString("title"),
        q1Data.getString("content"),
        q1Data.getJSONArray("tags").getStringArray());

    user2.askQuestion(
        q3Data.getString("title"),
        q3Data.getString("content"),
        q3Data.getJSONArray("tags").getStringArray());

    currentQuestion = user1.questions.get(0);

    if (q1Data.getFloat("quality") > 0.5) {
        user2.upvote(currentQuestion);
        user3.upvote(currentQuestion);
        currentQuestion.addComment(new Comment(
            user2, currentQuestion, commentsPos[round(random(0, commentsPos.length - 1))]));
        currentQuestion.addComment(new Comment(
            user3, currentQuestion, commentsPos[round(random(0, commentsPos.length - 1))]));
    } else {
        user2.downvote(currentQuestion);
        user3.downvote(currentQuestion);
        currentQuestion.addComment(new Comment(
            user2, currentQuestion, commentsNeg[round(random(0, commentsNeg.length - 1))]));
        currentQuestion.addComment(new Comment(
            user3, currentQuestion, commentsNeg[round(random(0, commentsNeg.length - 1))]));
    }

    user3.upvote(currentQuestion.comments.get(0));
    user2.upvote(currentQuestion.comments.get(1));

    currentAnswer = new Answer(
        user2, currentQuestion, _getAnswer(currentQuestion, answers).getString("content"));

    currentQuestion.answer(currentAnswer);

    currentQuestion.markBestAnswer(currentAnswer);

    currentAnswer.addComment(new Comment(
        user1, currentQuestion, commentsPos[round(random(0, commentsPos.length - 1))]));

    user1.upvote(currentAnswer);
    user2.upvote(currentAnswer.comments.get(0));

    println(repeat("-", 75));
    println(currentAnswer);

    println(repeat("-", 75));
    println(currentQuestion);

    println(repeat("-", 75));
    println(user1);
    println(user2);

    currentQuestion = user2.questions.get(0);

    if (q1Data.getFloat("quality") > 0.5) {
        user1.upvote(currentQuestion);
        currentQuestion.addComment(new Comment(
            user1, currentQuestion, commentsPos[round(random(0, commentsPos.length - 1))]));
    } else {
        user1.downvote(currentQuestion);
        currentQuestion.addComment(new Comment(
            user1, currentQuestion, commentsNeg[round(random(0, commentsNeg.length - 1))]));
    }

    user3.upvote(currentQuestion.comments.get(0));

    currentAnswer = new Answer(
        user2, currentQuestion, _getAnswer(currentQuestion, answers).getString("content"));

    currentQuestion.answer(currentAnswer);

    currentAnswer = new Answer(
        user1, currentQuestion, _getAnswer(currentQuestion, answers).getString("content"));

    currentQuestion.answer(currentAnswer);
    currentAnswer.addComment(new Comment(
        user2, currentQuestion, commentsPos[round(random(0, commentsPos.length - 1))]));

    println(repeat("-", 75));
    println(currentQuestion);

    println(repeat("-", 75));
    if (allTags.containsKey("python")) {
        println(allTags.get("python").getQuestionsString());

        Comment newComment = new Comment(
            user3, currentQuestion, commentsNeg[round(random(0, commentsNeg.length - 1))]);

        allTags.get("python").questions.get(0).addComment(newComment);
        user1.upvote(newComment);
    } else {
        println("No questions with the python tag were found");
    }

    println(repeat("-", 75));
    println(user1);
    println(user2);
    println(user3);

    exit();
}
