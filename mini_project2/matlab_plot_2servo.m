clear all


arduinoComPort = 'COM5';  % set serial port
baudRate = 9600;  % set the baud rate

% open the serial port, close it first in case it was previously open
fclose(instrfind({'Port','Status'},{arduinoComPort,'open'}));
serialPort = serial(arduinoComPort, 'BAUD', baudRate);
fopen(serialPort);
fprintf(serialPort, '\n');

% initialize a timeout in case MATLAB cannot connect to the arduino
timeout = 0;

x_values = [];
y_values = [];
z_values = [];
loop_index = 1;

% main loop to read data from the Arduino
while timeout < 5
    % check if data was received
    while serialPort.BytesAvailable > 0
        timeout = 0;    % reset timeout
        % data received from Arduino, convert it into array of integers
        values = eval(strcat('[',fscanf(serialPort),']'));

        % store the integers in three variables
        distance = values(1);
        pan_angle = values(2);
        
        if (distance)
            % polar to cartesian conversion
            x_values(loop_index) = pan_angle;
            y_values(loop_index) = distance;
            loop_index = loop_index + 1;
        end
    end
    pause(0.5);
    timeout = timeout + 1;
end

plot(x_values,y_values, '.')
title("3D Scanner Result");
xlabel("Pan angle (degree)");
ylabel("Distance (cms)");
