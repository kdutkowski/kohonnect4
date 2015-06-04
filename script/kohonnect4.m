function normalized = normalize(x)
  if ~isvector(x)
      error('Input must be a vector')
  end
  normalized = x./sqrt(sum(x.^2));
  normalized(!isfinite(normalized))=0;
end

global WIDTH = 7;
global HEIGHT = 6;
global INPUTS = WIDTH*HEIGHT;
global RATE = 0.00001;
global ITERATIONS = 1000;

function score = compute_score(weights, test_examples, test_answers)
  global WIDTH
  global INPUTS
  actuals = test_answers;
  for example_index = 1:size(test_examples)
    input = repmat(test_examples(example_index,:), 1, WIDTH);
    input_signal = weights.*input;
    output_index = 1:INPUTS: length(weights);
    neurons_outputs = zeros(WIDTH, 1);
    for output = 2:WIDTH
      neurons_outputs(output-1) = [sum(input_signal(output_index(output-1):output_index(output)))];
    endfor
    [value, index] =  max(neurons_outputs);
    actuals(example_index) = index-1;
  endfor
  score = sum((actuals-test_answers) == 0) / length(test_answers);
end



weights = rand(1,WIDTH*INPUTS);

for index = 0:7:length(weights)-WIDTH
  weights(index+1:index+WIDTH) = normalize(weights(index+1:index+WIDTH));
endfor

data = csvread(argv(){1});
test_data = csvread(argv(){2});
test_examples = test_data(:, 1:INPUTS);
test_answers = test_data(:, INPUTS+1);

examples = data(:, 1:INPUTS);
answers = data(:, INPUTS+1);

printf("iteration,training_score,test_score\n")

for iteration = 1:ITERATIONS
  RATE = 1 / (1+iteration);
  for example_index = 1:size(examples)
    example = examples(example_index, :);
    from = 1+(answers(example_index))*INPUTS;
    to = (answers(example_index)+1)*INPUTS;
    weights(from:to) = normalize(weights(from:to) + RATE*(example-weights(from:to)));
  endfor
  test_score = compute_score(weights, test_examples, test_answers);
  training_score = compute_score(weights, examples, answers);
  printf("%d,%f,%f\n", iteration , training_score, test_score)


endfor
