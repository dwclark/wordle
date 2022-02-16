(declaim (optimize (speed 0) (space 0) (debug 3)))


(defun read-file (file-name)
  (with-open-file (stm file-name)
    (loop for line = (read-line stm nil)
          while line
          collect line)))

(defvar *word-list* nil)
(defvar *frequencies* nil)

(defun word-score (word)
  (loop for c across word
        for i from 0 to 4
        summing (aref (aref *frequencies* i) (- (char-code c) 97)) into score
        finally (return score)))

(defun word> (w1 w2)
  (> (word-score w1) (word-score w2)))

(defun analyze-words ()
  (setf *frequencies* (make-array 5))
  
  (loop for i from 0 to 4
        do (setf (aref *frequencies* i) (make-array 26 :element-type 'fixnum :initial-element 0)))
  
  (loop for word in *word-list*
        do (loop for c across word
                 for i from 0 to 4
                 do (let ((vec (aref *frequencies* i))
                          (idx (- (char-code c) 97)))
                      (incf (aref vec idx)))))
  
  (sort *word-list* #'word>))

(defun words-from (file-name &optional (always nil))
  (when (or always (not *word-list*))
    (setf *word-list* (read-file file-name))
    (setf *word-list* (analyze-words))
    nil))

(defun letter-in-position (str)
  (if (and (= 2 (length str))
           (not (char= #\! (elt str 0))))
      (let ((pos (- (char-code (elt str 0)) 49))
            (ch (elt str 1)))
        #'(lambda (word)
            (char= ch (elt word pos))))))

(defun no-letter (str)
  (if (and (= 2 (length str))
           (char= #\! (elt str 0)))
      (let ((ch (elt str 1)))
        #'(lambda (word)
            (not (find ch word :test #'char=))))))

(defun letter-not-in-position (str)
  (if (= 3 (length str))
      (let ((pos (- (char-code (elt str 1)) 49))
            (ch (elt str 2)))
        #'(lambda (word)
            (and (find ch word :test #'char=)
                 (not (char= ch (elt word pos))))))))

(defun sym->func (s)
  (let ((str (string-downcase (symbol-name s))))
    (or (letter-in-position str)
        (no-letter str)
        (letter-not-in-position str))))
                      
(defun funcs-matcher (specs)
  (let ((funcs (mapcar #'sym->func specs)))
    #'(lambda (word)
        (loop for func in funcs
              do (if (not (funcall func word))
                     (return nil))
              finally (return t)))))

(defun best-guess-p (word)
  (let ((my-set nil))
    (loop for ch across word
          do (setf my-set (adjoin ch my-set :test #'char=))
          finally (return (if (= 5 (length my-set)) t nil)))))

(defun best-guesses (&optional num (lst (remove-if-not #'best-guess-p *word-list*)))
  (let ((last-index (if num num (length lst))))
    (subseq (sort lst #'word>) 0 last-index)))

(defun possibilities (specs)
  (let* ((all (remove-if-not (funcs-matcher specs) *word-list*))
         (best-guesses (best-guesses nil (remove-if-not #'best-guess-p all))))
    (format t "All:~%~A~%~%" all)
    (format t "Best Guesses: ~%~A~%~%" best-guesses)))
        
(defmacro play-wordle (&rest specs)
  `(funcall #'possibilities '(,@specs)))
