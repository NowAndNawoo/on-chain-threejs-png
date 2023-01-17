import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import earth from './image/earth.png';

const size = { width: window.innerWidth, height: window.innerHeight };
const scene = new THREE.Scene();
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
const light1 = new THREE.AmbientLight(0x202020);
const light2 = new THREE.PointLight();
light2.position.set(2, 2, 2);
scene.add(sphere, light1, light2);

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
