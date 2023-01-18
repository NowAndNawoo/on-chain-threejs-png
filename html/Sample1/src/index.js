import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import earth from './image/earth.png';

const size = { width: window.innerWidth, height: window.innerHeight };
const scene = new THREE.Scene();
scene.background = new THREE.Color('#06041c');
const camera = new THREE.PerspectiveCamera(75, size.width / size.height, 0.1, 1000);
camera.position.z = 2;
camera.position.y = 1;
camera.lookAt(0, 0, 0);
const renderer = new THREE.WebGLRenderer();
renderer.setSize(size.width, size.height);
renderer.setPixelRatio(window.devicePixelRatio);
document.body.appendChild(renderer.domElement);

const geometry = new THREE.SphereGeometry(1, 80, 40);
const texture = new THREE.TextureLoader().load(earth);
const material = new THREE.MeshStandardMaterial({ map: texture });
material.roughness = 0.4;
const sphere = new THREE.Mesh(geometry, material);

const starsVertices = [];
for (let i = 0; i < 1000; i++) {
  const v = new THREE.Vector3(Math.random() - 0.5, Math.random() - 0.5, Math.random() - 0.5);
  const { x, y, z } = v.setLength(10 + Math.random() * 50);
  starsVertices.push(x, y, z);
}
const starsGeometry = new THREE.BufferGeometry();
starsGeometry.setAttribute('position', new THREE.Float32BufferAttribute(starsVertices, 3));
const starsMaterial = new THREE.PointsMaterial({ size: 0.03, color: 0xffffff });
const stars = new THREE.Points(starsGeometry, starsMaterial);

const light1 = new THREE.AmbientLight(0x202020);
const light2 = new THREE.PointLight();
light2.position.set(2, 2, 2);

scene.add(stars, sphere, light1, light2);

const controls = new OrbitControls(camera, document.body);

window.addEventListener('resize', () => {
  size.width = window.innerWidth;
  size.height = window.innerHeight;
  camera.aspect = size.width / size.height;
  camera.updateProjectionMatrix();
  renderer.setSize(size.width, size.height);
  renderer.setPixelRatio(window.devicePixelRatio);
});

const clock = new THREE.Clock();
const animate = function () {
  requestAnimationFrame(animate);
  sphere.rotation.y += clock.getDelta() * 0.1;
  renderer.render(scene, camera);
};
animate();
