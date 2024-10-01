<?php

declare(strict_types=1);

namespace App\Health\Infrastructure\Controller;

use App\Health\Infrastructure\Request\GetHealthRequest;
use App\Health\Infrastructure\Response\GetHealthResponse;
use App\SharedKernel\Infrastructure\Controller\ControllerInterface;
use App\SharedKernel\Infrastructure\RequestDTOInterface;
use App\SharedKernel\Infrastructure\ResponseDTOInterface;
use Symfony\Component\Routing\Attribute\Route;

final class HealthController implements ControllerInterface
{
    #[Route('/health', name: 'health', methods: ['GET'])]
    public function handleResponse(GetHealthRequest|RequestDTOInterface $request): ResponseDTOInterface
    {
        return new GetHealthResponse();
    }
}
