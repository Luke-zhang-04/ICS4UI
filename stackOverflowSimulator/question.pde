/**
 * StackOverflow "Simulator" | OOP Project
 * @author Luke Zhang
 */

private
int _questionId = 0;

/**
 * Class for a question
 * Inheritance goes as follows: Question extends Post extends Item
 */
class Question extends Post {
    public
    final ArrayList<Tag> tags = new ArrayList<Tag>();

    public
    Answer bestAnswer = null;

    public
    final ArrayList<Answer> answers = new ArrayList<Answer>();

    public
    final String title;

    public
    Question(User user, String title, String content, long timestamp, String[] tags) {
        super(user, _questionId, content, timestamp);

        user.questions.add(this);
        this.title = title;
        _questionId++;
        this._setTags(tags);
    }

    public
    Question(User user, String title, String content, String[] tags) {
        super(user, _questionId, content);

        user.questions.add(this);
        this.title = title;
        _questionId++;
        this._setTags(tags);
    }

    public
    Question(User user, String title, String content, long timestamp) {
        this(user, title, content, timestamp, new String[0]);
    }

    public
    Question(User user, String title, String content) {
        this(user, title, content, new String[0]);
    }

    public
    Answer answer(Answer answer) {
        this.answers.add(answer);

        return answer;
    }

    public
    Answer markBestAnswer(int id) {
        if (this.bestAnswer != null) {
            return this.bestAnswer;
        }

        for (Answer answer : this.answers) {
            if (answer.id == id) {
                answer.isBestAnswer = true;
                this.bestAnswer = answer;

                return answer;
            }
        }

        return null;
    }

    public
    Answer markBestAnswer(Answer bestAnswer) {
        if (this.bestAnswer != null) {
            return this.bestAnswer;
        }

        if (bestAnswer.question.id == this.id) {
            bestAnswer.isBestAnswer = true;
            this.bestAnswer = bestAnswer;

            return bestAnswer;
        }

        return null;
    }

    @Override public String toString() {
        return String.format(
            "QUESTION - %d - by %s - **%s**\n\n%s\n\nTAGS: %s\n\nCOMMENTS:\n%s\n\nANSWERS:\n%s",
            this.getScore(),
            this.user.name,
            this.title,
            this.content,
            this.getTagsString(),
            this.getCommentsString(),
            this.getAnswersString());
    }

    protected
    String getAnswersString() {
        String answersString = "";

        for (Answer answer : this.answers) {
            answersString += "\n" + answer.toString();
        }

        return answersString.trim();
    }

    protected
    String getTagsString() {
        final ArrayList<String> stringTags = new ArrayList<String>();

        for (Tag tag : this.tags) {
            stringTags.add(tag.toString());
        }

        return String.join(", ", stringTags);
    }

    /** Sets the tags for the question and globally */
    private
    void _setTags(String[] tags) {
        for (String tag : tags) {
            if (tag != null) {
                boolean isExistingTag = allTags.containsKey(tag);
                Tag targetTag = isExistingTag ? allTags.get(tag) : new Tag(tag);

                if (!isExistingTag) {            // If the tag doesn't exist
                    allTags.put(tag, targetTag); // Create a new tag
                }

                targetTag.questions.add(this); // Add this question to that tag
                this.tags.add(targetTag);      // Add this tag to this question
            }
        }
    }
}
