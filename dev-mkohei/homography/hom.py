import numpy as np

# 変換前 (xi, yi)
B = np.array([
    [158, 103],
    [549, 103],
    [190, 295],
    [520, 300]
])

# 変換後 (Xi, Yi)
A = np.array([
    [0, 0],
    [1920, 0],
    [0, 1080],
    [1920, 1080]
])

x = np.matrix([A[0,0],A[1,0],A[2,0],A[3,0],A[0,1],A[1,1],A[2,1],A[3,1]]).T

P = np.matrix([
    [ B[0,0], B[0,1], 1, 0, 0, 0, -A[0,0]*B[0,0], -A[0,0]*B[0,1] ],
    [ B[1,0], B[1,1], 1, 0, 0, 0, -A[1,0]*B[1,0], -A[1,0]*B[1,1] ],
    [ B[2,0], B[2,1], 1, 0, 0, 0, -A[2,0]*B[2,0], -A[2,0]*B[2,1] ],
    [ B[3,0], B[3,1], 1, 0, 0, 0, -A[3,0]*B[3,0], -A[3,0]*B[3,1] ],
    [ 0, 0, 0, B[0,0], B[0,1], 1, -A[0,1]*B[0,0], -A[0,1]*B[0,1] ],
    [ 0, 0, 0, B[1,0], B[1,1], 1, -A[1,1]*B[1,0], -A[1,1]*B[1,1] ],
    [ 0, 0, 0, B[2,0], B[2,1], 1, -A[2,1]*B[2,0], -A[2,1]*B[2,1] ],
    [ 0, 0, 0, B[3,0], B[3,1], 1, -A[3,1]*B[3,0], -A[3,1]*B[3,1] ],
])

a = (P.I * x)

H = np.matrix([
    [ a[0,0], a[1,0], a[2,0] ],
    [ a[3,0], a[4,0], a[5,0] ],
    [ a[6,0], a[7,0], 1]
])

y = np.matrix([200,200,1]).T


# 変換したい座標 (x,y)に対して
# [x,y,1].T * H
# によって変換後の座標が求まる

# 例
# (200,200)
# ->
#[[ 122.04688386]
# [ 430.71513421]
# [   0.86247463]]
# だいたい合ってそう...
