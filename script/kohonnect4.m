function normalized = normalize(x)
  if ~isvector(x)
      error('Input must be a vector')
  end
  normalized = x./sqrt(sum(x.^2));
  normalized(!isfinite(normalized))=0;
end

WIDTH = 7;
HEIGHT = 6;
INPUTS = WIDTH*HEIGHT;
RATE = 0.001;
ITERATIONS = 100;

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

for iteration = 1:ITERATIONS
  for example_index = 1:size(examples)
    example = examples(example_index, :);
    from = 1+(answers(example_index))*INPUTS;
    to = (answers(example_index)+1)*INPUTS;
    weights(from:to) = normalize(weights(from:to) + RATE*(example-weights(from:to)));
  endfor
  %RATE = 1/INPUTS;
  %RATE = RATE / 2;
  %RATE = RATE / e;
  RATE = RATE * exp(-iteration*HEIGHT/(200*ITERATIONS));
  %RATE = RATE / 10;
  %RATE = 1/iteration;
  %RATE = 1/iteration^2;
  %RATE = 1/log(iteration)^2;

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
  printf("%d,%f\n", iteration , score)

endfor
