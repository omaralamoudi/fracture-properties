# Details about the functions used in the script `ShapesOfGaussians.m`
This script shows how the Gaussian function looks in different dimensions. 

## 1D Gaussian function

$$
g(x) = A_0\exp \left[ -\frac{1}{2}\frac{(x-x_0)^2}{\sigma^2} \right]
$$

Where
$$
\begin{align*}
A_0: & ~\text{amplitude at } x_0\\
x_0: & ~\text{the point along the $x$ axis where $g(x)$ is centered}\\
\sigma: & ~\text{a scaling coeffecient [more details are needed]}
\end{align*}
$$

To produce a function $g(x)$ with unity area under the curve $A_0 = \frac{1}{\sigma \sqrt{2\pi}}$ as is the case in probability density function of normal/gaussian distribution.


## 2D Gaussian function

$$
g(x,y) = A_0 \exp{\left\{ -\frac{1}{2}\left[ \frac{(x-x_0)^2}{\sigma_x^2} + \frac{(y-y_0)^2}{\sigma_y^2} \right] \right\}}
$$

Thinking further about $A_0$, which the amplitude ( or height) of the function $g(x,y)$ at the point $(x_0,y_0)$. We can split the the function into two factors as such:
$$
g(x,y) = {A_0}_x \exp \left[ -\frac{1}{2} \frac{(x-x_0)^2}{{\sigma_x}^2} \right] ~ {A_0}_y \left[ -\frac{1}{2} \frac{(y-y_0)^2}{{\sigma_y}^2} \right]
$$
To produce a function $g(x,y)$ that integrates to unity, we follow the same approach shown in the 1D case to determine the amplitudes  ${A_0}_x$ and ${A_0}_y$, that results in:
$$
\begin{align*}
{A_0}_x & = ~ \frac{1}{{\sigma_x} \sqrt{2 \pi}} \\
{A_0}_y & = ~ \frac{1}{{\sigma_y} \sqrt{2 \pi}} \\
\text{Therefore} & \\
{A_0} & = {A_0}_x {A_0}_y = ~ \frac{1}{{\sigma_x}{\sigma_y} \sqrt{(2 \pi)^2}} \\
\end{align*}
$$


### Quadratic form

Simplifying the exponent, this can be generalized as following:
$$
g(x,y) = A_0 \exp{ \left\{-\frac{1}{2}\left[ \mathbf{x}^T \mathbf{B} \mathbf{x}\right] \right\} }
$$
Where 
$$
\mathbf{x} = [(x - x_0) \quad (y - y_0)]^T
$$
And
$$
\mathbf{B} =
\begin{bmatrix}
\frac{1}{\sigma_x^2} & 0 \\
0 & \frac{1}{{\sigma_y}^2}
\end{bmatrix}
$$

### General Quadratic Form

Considering the exponent, this can be generalized as following
$$
g(x,y) = A_0 \exp{ \left\{-\left[ \mathbf{x}^T \mathbf{B} \mathbf{x}\right] \right\} }
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
g(x,y) = A_0 \exp{-\left\{ B_{11}(x-x_0)^2 + B_{12}(x-x_0)(y-y_0) + B_{21} (x-x_0)(y-y_0) + B_{22}(y-y_0)^2 \right\}}
$$
In the previous case, $\mathbf{B}$ was symmetric $\mathbf{B} = \mathbf{B}^T$ , and diagonal where $B_{12} = B_{21} = 0$. Therefore, the two middle terms vanish, and $B_{11} = \frac{1}{2\sigma_x^2}$, $B_{22} = \frac{1}{2\sigma_y^2}$





## 3D Gaussian function

$$
g(x,y,z) = A_0 \exp{-\left[ \frac{1}{2}\frac{(x-x_0)^2}{\sigma_x^2} + \frac{1}{2}\frac{(y-y_0)^2}{\sigma_y^2} + \frac{1}{2}\frac{(z-z_0)^2}{\sigma_z^2} \right]}
$$

### General quadratic form

# Things to note

Above, I state that 
$$
\mathbf{B} =
\begin{bmatrix}
\frac{1}{\sigma_x^2} & 0 \\
0 & \frac{1}{{\sigma_y}^2}
\end{bmatrix}
$$
But I think this might be wrong. 

# References

[1]: https://en.wikipedia.org/wiki/Gaussian_function "Gaussian function"
[2]: https://en.wikipedia.org/wiki/Normal_distribution " Normal Distribution"
[3]: https://cs229.stanford.edu/section/gaussians.pdf "The Multivariate Gaussian Distribution by Chuong B. Do"
[4]: https://en.wikipedia.org/wiki/Covariance_matrix "Covariance Matrix"
[5]: https://en.wikipedia.org/wiki/Multivariate_normal_distribution "Multivariate Normal Distribution"
[6]: https://en.wikipedia.org/wiki/Multivariate_random_variable "Multivariate random variable"

