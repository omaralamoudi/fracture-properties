# Details about the functions used in the script `ShapesOfGaussians.m`
This script shows how the Gaussian function looks in different dimentions. 

## 1D Gaussian function

$$
f(x) = A_0\exp - \left[ \frac{1}{2}\frac{(x-x_0)^2}{\sigma^2} \right]
$$

Where ... [I need to explain the variables]





## 2D Gaussian function

$$
f(x,y) = A_0 \exp{-\left[ \frac{1}{2}\frac{(x-x_0)^2}{\sigma_x^2} + \frac{1}{2}\frac{(y-y_0)^2}{\sigma_y^2} \right]}
$$

### Quadratic form

Consering the exponent, this can be generalized as following
$$
f(x,y) = A_0 \exp{ \left\{-\left[ \mathbf{x}^T \mathbf{B} \mathbf{x}\right] \right\} }
$$
Where 
$$
\mathbf{x} = [(x - x_0) \quad (y - y_0)]^T
$$
And
$$
\mathbf{B} = \frac{1}{2}
\begin{bmatrix}
\frac{1}{\sigma_x^2} & 0 \\
0 & \frac{1}{{\sigma_y}^2}
\end{bmatrix}
$$

### General Quadratic Form

Consering the exponent, this can be generalized as following
$$
f(x,y) = A_0 \exp{ \left\{-\left[ \mathbf{x}^T \mathbf{B} \mathbf{x}\right] \right\} }
$$
Where 
$$
\mathbf{x} = [(x - x_0) \quad (y - y_0)]^T
$$
And
$$
\mathbf{B} = 
\begin{bmatrix}
B_{11} & B_{12} \\
B_{21} & B_{22}
\end{bmatrix}
$$
Resulting in 
$$
f(x,y) = A_0 \exp{-\left\{ B_{11}(x-x_0)^2 + B_{12}(x-x_0)(y-y_0) + B_{21} (x-x_0)(y-y_0) + B_{22}(y-y_0)^2 \right\}}
$$
In the previous case, $\mathbf{B}$ was symmetric $\mathbf{B} = \mathbf{B}^T$ , and $B_{12} = B_{21} = 0$. Therefore, the two middle terms vanished, and $B_{11} = \frac{1}{2\sigma_x^2}$, $B_{22} = \frac{1}{2\sigma_y^2}$





## 3D Gaussian function

$$
f(x,y,z) = A_0 \exp{-\left[ \frac{1}{2}\frac{(x-x_0)^2}{\sigma_x^2} + \frac{1}{2}\frac{(y-y_0)^2}{\sigma_y^2} + \frac{1}{2}\frac{(z-z_0)^2}{\sigma_z^2} \right]}
$$

### General quadratic form